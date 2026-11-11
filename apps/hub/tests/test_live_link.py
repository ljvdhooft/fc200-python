import asyncio
import json

from fc200_hub import ui_protocol as proto
from fc200_hub.hub import Hub
from fc200_hub.live_link import LiveLink

from conftest import SNAPSHOT


async def until(cond, timeout=3.0):
    async with asyncio.timeout(timeout):
        while not cond():
            await asyncio.sleep(0.01)


class FakeScript:
    """A tiny TCP server speaking the script side of the protocol."""

    def __init__(self):
        self.writers = []
        self.received = []
        self.server = None

    async def start(self, port=0):
        self.server = await asyncio.start_server(self._on_client, "127.0.0.1", port)
        return self.server.sockets[0].getsockname()[1]

    async def _on_client(self, reader, writer):
        self.writers.append(writer)
        writer.write(proto.encode(proto.event("state.snapshot", SNAPSHOT)))
        while line := await reader.readline():
            msg = json.loads(line)
            self.received.append(msg)
            writer.write(proto.encode(proto.response(msg["id"], {"echo": msg["method"]})))
        writer.close()

    async def drop(self):
        for w in self.writers:
            w.close()
        self.writers.clear()

    async def stop(self):
        await self.drop()
        self.server.close()
        await self.server.wait_closed()


async def test_link_drop_and_recovery():
    script = FakeScript()
    port = await script.start()
    hub = Hub(timeout=1)
    link = LiveLink(hub, port=port, backoff_min=0.05, backoff_max=0.1)
    task = asyncio.create_task(link.run())
    try:
        await until(lambda: hub.live_connected and hub.state)
        assert hub.state["hub"]["live_connected"] is True

        # patches from the script update the cache
        script.writers[0].write(proto.encode(proto.event("state.patch", {"tempo": 77.0})))
        await until(lambda: hub.state["tempo"] == 77.0)

        # request round trip with a rewritten id
        reply = await hub.request("page.set", {"page": 1})
        assert reply["result"] == {"echo": "page.set"}

        # drop: live_connected false, stale cache kept, requests refused
        await script.stop()
        await until(lambda: not hub.live_connected)
        assert hub.state["hub"]["live_connected"] is False
        assert hub.state["tempo"] == 77.0
        assert (await hub.request("page.set", {}))["error"]["code"] == "live_offline"

        # recovery: a new script on the same port, snapshot replaces the cache
        script2 = FakeScript()
        await script2.start(port)
        # live_connected flips on connect, the snapshot follows a moment later
        await until(lambda: hub.live_connected and hub.state["tempo"] == SNAPSHOT["tempo"])
        assert hub.state["hub"]["live_connected"] is True
        await script2.stop()
    finally:
        task.cancel()
