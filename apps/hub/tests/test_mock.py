import asyncio

from fc200_hub.hub import Hub
from fc200_hub.mock import Mock


async def test_mock_serves_snapshot_and_answers_methods():
    hub = Hub(timeout=1)
    mock = Mock(hub)
    task = asyncio.create_task(mock.run())
    try:
        await asyncio.sleep(0.05)
        assert hub.live_connected and hub.state["page"] == 2
        reply = await hub.request("param.set", {"loop": 2, "parameter": 3, "value": 0.8})
        assert reply["result"]["value"] == 0.8
        await asyncio.sleep(0.25)
        assert hub.state["edit"]["macros"][2]["value"] == 0.8
        assert (await hub.request("nope", {}))["error"]["code"] == "unknown_method"
        assert (await hub.request("loop.set", {"loop": 99, "on": True}))["error"]["code"] == "not_found"
    finally:
        task.cancel()
