"""The relay: cache of the latest state, fan-out to WebSocket clients, request routing.

Generic by design: it knows no state paths except the `hub` node it adds itself.
A backend (LiveLink or Mock) feeds it and carries requests to the script.
"""

from __future__ import annotations

import asyncio
import copy
import logging
from typing import Any, Protocol

from aiohttp import web

from . import ui_protocol as proto

log = logging.getLogger(__name__)

REQUEST_TIMEOUT = 2.0


class Backend(Protocol):
    def send(self, message: proto.Message) -> bool:
        """Send a request to the script; False if there is no link."""
        ...


class Hub:
    def __init__(self, timeout: float = REQUEST_TIMEOUT) -> None:
        self.timeout = timeout
        self.backend: Backend | None = None
        self.state: dict[str, Any] | None = None  # None until a snapshot arrived
        self.live_connected = False
        self.clients: set[web.WebSocketResponse] = set()
        self._pending: dict[int, asyncio.Future[proto.Message]] = {}
        self._next_id = 1

    # --- feed from the backend -------------------------------------------------

    def on_snapshot(self, snapshot: dict[str, Any]) -> None:
        self.state = copy.deepcopy(snapshot)
        self._stamp_hub()
        self._broadcast(proto.event("state.snapshot", self.state))

    def on_patch(self, patch: proto.Patch) -> None:
        if self.state is None:
            return
        try:
            proto.apply_patch(self.state, patch)
        except (KeyError, IndexError, ValueError, TypeError):
            log.warning("patch does not apply, ignored: %r", patch)
            return
        self._broadcast(proto.event("state.patch", patch))

    def on_event(self, message: proto.Message) -> None:
        self._broadcast(message)

    def on_response(self, message: proto.Message) -> None:
        future = self._pending.pop(message.get("id"), None)  # type: ignore[arg-type]
        if future and not future.done():
            future.set_result(message)

    def set_live(self, connected: bool) -> None:
        if connected == self.live_connected:
            return
        self.live_connected = connected
        self._stamp_hub()
        if not connected:
            for future in self._pending.values():
                if not future.done():
                    future.set_result(proto.error_response(None, "live_offline", "link to Live lost"))
            self._pending.clear()
        self._broadcast(self._status())

    # --- clients -----------------------------------------------------------------

    def _stamp_hub(self) -> None:
        if self.state is not None:
            self.state["hub"] = {"live_connected": self.live_connected}

    def _status(self) -> proto.Message:
        return proto.event("hub.status", {"live_connected": self.live_connected})

    def _broadcast(self, message: proto.Message) -> None:
        for ws in list(self.clients):
            asyncio.ensure_future(self._send(ws, message))

    @staticmethod
    async def _send(ws: web.WebSocketResponse, message: proto.Message) -> None:
        if ws.closed:
            return
        try:
            await ws.send_str(proto.encode(message).decode().rstrip("\n"))
        except ConnectionError:
            pass

    async def request(self, method: str, params: dict[str, Any]) -> proto.Message:
        """Forward a request under a hub-owned id; always returns a response message."""
        if not self.live_connected or self.backend is None:
            return proto.error_response(None, "live_offline", "no link to Live")
        hub_id = self._next_id
        self._next_id += 1
        future: asyncio.Future[proto.Message] = asyncio.get_running_loop().create_future()
        self._pending[hub_id] = future
        if not self.backend.send(proto.request(hub_id, method, params)):
            self._pending.pop(hub_id, None)
            return proto.error_response(None, "live_offline", "no link to Live")
        try:
            return await asyncio.wait_for(future, self.timeout)
        except TimeoutError:
            self._pending.pop(hub_id, None)
            return proto.error_response(None, "timeout", f"no response within {self.timeout:g} s")

    async def handle_ws(self, request: web.Request) -> web.WebSocketResponse:
        ws = web.WebSocketResponse(heartbeat=20)
        await ws.prepare(request)
        if self.state is not None:
            await self._send(ws, proto.event("state.snapshot", self.state))
        await self._send(ws, self._status())
        self.clients.add(ws)
        tasks: set[asyncio.Task[None]] = set()
        try:
            async for msg in ws:
                if msg.type != web.WSMsgType.TEXT:
                    continue
                task = asyncio.create_task(self._handle_message(ws, msg.data))
                tasks.add(task)
                task.add_done_callback(tasks.discard)
        finally:
            self.clients.discard(ws)
            for task in tasks:
                task.cancel()
        return ws

    async def _handle_message(self, ws: web.WebSocketResponse, text: str) -> None:
        try:
            message = proto.decode(text)
        except proto.ProtocolError as e:
            await self._send(ws, proto.error_response(None, "bad_params", str(e)))
            return
        if "method" not in message:
            return  # clients only send requests
        reply = await self.request(message["method"], message.get("params", {}))
        reply["id"] = message["id"]  # route back under the client's own id
        await self._send(ws, reply)
