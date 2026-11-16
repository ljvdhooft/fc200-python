"""TCP client to the Remote Script (127.0.0.1:20030) with reconnect and backoff.

Live counts as connected once the script's first state.dump arrives, not on the
TCP connect: a script instance that Live dropped without disconnect() can still
accept the connection but never answers.
"""

from __future__ import annotations

import asyncio
import logging

from . import ui_protocol as proto
from .hub import Hub

log = logging.getLogger(__name__)

DUMP_TIMEOUT = 5.0  # s; warn when a connected script hasn't sent its dump by then


class LiveLink:
    def __init__(self, hub: Hub, host: str = "127.0.0.1", port: int = 20030,
                 backoff_min: float = 0.5, backoff_max: float = 5.0) -> None:
        self.hub = hub
        self.host = host
        self.port = port
        self.backoff_min = backoff_min
        self.backoff_max = backoff_max
        self._writer: asyncio.StreamWriter | None = None
        hub.backend = self

    def send(self, message: proto.Message) -> bool:
        if self._writer is None:
            return False
        self._writer.write(proto.encode(message))
        return True

    async def run(self) -> None:
        delay = self.backoff_min
        while True:
            try:
                reader, writer = await asyncio.open_connection(self.host, self.port)
            except OSError:
                await asyncio.sleep(delay)
                delay = min(delay * 2, self.backoff_max)
                continue
            delay = self.backoff_min
            self._writer = writer
            log.info("connected to Live at %s:%s", self.host, self.port)
            silent = asyncio.get_running_loop().call_later(
                DUMP_TIMEOUT, log.warning,
                "no state.dump from Live within %g s: is the Remote Script stuck? Restart Live", DUMP_TIMEOUT)
            try:
                await self._read(reader, silent)
            except (OSError, asyncio.IncompleteReadError, ValueError):
                pass
            finally:
                silent.cancel()
                self._writer = None
                writer.close()
                self.hub.set_live(False)
                log.info("Live link lost")

    async def _read(self, reader: asyncio.StreamReader, silent: asyncio.TimerHandle) -> None:
        while line := await reader.readline():
            try:
                message = proto.decode(line)
            except proto.ProtocolError as e:
                log.warning("bad line from Live: %s", e)
                continue
            name = message.get("event")
            if name == "state.dump":
                silent.cancel()
                self.hub.set_live(True)  # before the dump, so the dump carries it
                self.hub.on_dump(message["data"])
            elif name == "state.changed":
                self.hub.on_changes(message["data"])
            elif name is not None:
                self.hub.on_event(message)
            elif "command" in message:
                self.hub.on_command(message)
            else:
                self.hub.on_response(message)
