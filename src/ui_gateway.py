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
        self._server: socket.socket | None = None
        try:
            server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            server.bind((host, port))
            server.listen()
            server.setblocking(False)
            self._server = server
        except OSError as e:
            # Most likely a second FC200 script holds the port: run without a frontend
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

    def close(self) -> None:
        for client in self._clients:
            client.sock.close()
        self._clients.clear()
        if self._server is not None:
            self._server.close()
            self._server = None

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
            reply = self._answer(line) if line.strip() else None
            if reply is not None:
                self._queue(client, reply)

    def _answer(self, line: bytes) -> proto.Message | None:
        """The response to a request line; None for events and responses, which
        clients have no reason to send."""
        try:
            message = proto.decode(line)
        except proto.ProtocolError as e:
            return proto.error_response(None, "bad_params", str(e))
        if "method" not in message:
            return None
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
