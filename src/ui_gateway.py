"""The script side of the frontend protocol (protocol/frontend.md): a TCP server
for the hub, and for `nc` while debugging.

There are no threads: FC200 calls poll() from update_display, so requests run on
Live's main thread like pedal events. One poll handles the requests that came in,
sends the StateModel's changes to the connected clients and greets new clients
with a dump. Sockets are non-blocking, and what a client can't take yet is
queued per client.

Handlers raise MethodError for an error response. Any other exception becomes
an `internal` error and is logged with a traceback, so a bad request never
breaks the script. No Live imports, so it can be unit-tested.

Live can create a new script instance without disconnecting the old one, which
then keeps the port but never polls again. Every instance runs in Live's one
Python process, so the newest gateway closes the previous one and takes the port.
"""

from __future__ import annotations

import socket
import traceback
from collections.abc import Callable
from typing import Any

from . import ui_protocol as proto

HOST = "127.0.0.1"
PORT = 20030
MAX_QUEUE = 1 << 20     # bytes; a client that falls this far behind is dropped

Handler = Callable[[dict[str, Any]], Any]

# The gateway listening on each (host, port), for the takeover. Port 0 (tests) isn't kept
_listening: dict[tuple[str, int], UiGateway] = {}


class MethodError(Exception):
    """Raised by a handler to answer with {"error": {"code", "message"}}."""

    def __init__(self, code: str, message: str) -> None:
        super().__init__(message)
        self.code = code
        self.message = message


class _Client:
    def __init__(self, sock: socket.socket) -> None:
        self.sock = sock
        self.inbox = b""
        self.outbox = b""


class UiGateway:
    def __init__(self, model: proto.StateModel, handlers: dict[str, Handler],
                 log: Callable[[str], None], host: str = HOST, port: int = PORT) -> None:
        self._model = model
        self._handlers = handlers
        self._log = log
        self._clients: list[_Client] = []
        self._address: tuple[str, int] | None = None
        self._server: socket.socket | None = None
        earlier = _listening.get((host, port))
        if earlier is not None:
            earlier.close()
            log("Frontend gateway: took the port over from an earlier FC200 instance")
        try:
            server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            server.bind((host, port))
            server.listen()
            server.setblocking(False)
            self._server = server
            if port != 0:
                self._address = (host, port)
                _listening[self._address] = self
        except OSError as e:
            # Most likely another Live (Suite and Beta) runs the script: run without a frontend
            log(f"Frontend gateway disabled, can't listen on {host}:{port}: {e}")

    @property
    def port(self) -> int | None:
        return self._server.getsockname()[1] if self._server is not None else None

    def poll(self) -> None:
        if self._server is None:
            return
        for client in list(self._clients):
            self._receive(client)
        changes = self._model.flush()
        if changes is not None:
            for client in list(self._clients):
                self._queue(client, proto.event("state.changed", changes))
        self._accept()
        for client in list(self._clients):
            self._send(client)

    def emit(self, message: proto.Message) -> None:
        """Queue an event for every client; it goes out on the next poll."""
        for client in list(self._clients):
            self._queue(client, message)

    def flush(self) -> None:
        """Send what is queued now instead of on the next poll (in order)."""
        for client in list(self._clients):
            self._send(client)

    def close(self) -> None:
        for client in self._clients:
            client.sock.close()
        self._clients.clear()
        if self._server is not None:
            self._server.close()
            self._server = None
        if self._address is not None and _listening.get(self._address) is self:
            del _listening[self._address]

    def _accept(self) -> None:
        assert self._server is not None
        while True:
            try:
                sock, _ = self._server.accept()
            except BlockingIOError:
                return
            sock.setblocking(False)
            client = _Client(sock)
            self._clients.append(client)
            self._queue(client, proto.event("state.dump", self._model.dump()))

    def _receive(self, client: _Client) -> None:
        while True:
            try:
                data = client.sock.recv(65536)
            except BlockingIOError:
                break
            except OSError:
                data = b""
            if not data:
                self._drop(client)
                return
            client.inbox += data
        *lines, client.inbox = client.inbox.split(b"\n")
        for line in lines:
            for reply in self._answer(line) if line.strip() else []:
                self._queue(client, reply)

    def _answer(self, line: bytes) -> list[proto.Message]:
        """What to send back for one line: the response to a request, nothing for
        events and responses (clients have no reason to send those)."""
        try:
            message = proto.decode(line)
        except proto.ProtocolError as e:
            return [proto.error_response(None, "bad_params", str(e))]
        if "method" not in message:
            return []
        if message["method"] == "state.dump":
            # Built in: the gateway owns the model. The dump goes to this client only.
            return [proto.response(message["id"], {}), proto.event("state.dump", self._model.dump())]
        return [self._call(message)]

    def _call(self, message: proto.Message) -> proto.Message:
        id = message["id"]
        handler = self._handlers.get(message["method"])
        if handler is None:
            return proto.error_response(id, "unknown_method", f"no method {message['method']!r}")
        try:
            return proto.response(id, handler(message.get("params", {})))
        except MethodError as e:
            return proto.error_response(id, e.code, e.message)
        except Exception:
            self._log(f"Error in {message['method']}:\n{traceback.format_exc()}")
            return proto.error_response(id, "internal", "see Live's Log.txt")

    def _queue(self, client: _Client, message: proto.Message) -> None:
        client.outbox += proto.encode(message)
        if len(client.outbox) > MAX_QUEUE:
            self._log("Frontend client too slow, dropping it")
            self._drop(client)

    def _send(self, client: _Client) -> None:
        if not client.outbox:
            return
        try:
            sent = client.sock.send(client.outbox)
        except BlockingIOError:
            return
        except OSError:
            self._drop(client)
            return
        client.outbox = client.outbox[sent:]

    def _drop(self, client: _Client) -> None:
        if client in self._clients:
            self._clients.remove(client)
            client.sock.close()
