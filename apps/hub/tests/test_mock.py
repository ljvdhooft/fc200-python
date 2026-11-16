import asyncio

from fc200_hub.hub import Hub
from fc200_hub.mock import Mock


async def test_mock_serves_dump_and_answers_methods():
    hub = Hub(timeout=1)
    mock = Mock(hub)
    task = asyncio.create_task(mock.run())
    try:
        await asyncio.sleep(0.05)
        assert hub.live_connected and hub.state["page"] == 2
        reply = await hub.request("loop.param.set", {"loop": 2, "parameter": 3, "value": 0.8})
        assert reply["result"]["value"] == 0.8
        await asyncio.sleep(0.25)
        assert hub.state["edit"]["macros"][2]["value"] == 0.8
        assert (await hub.request("nope", {}))["error"]["code"] == "unknown_method"
        assert (await hub.request("loop.set", {"loop": 99, "on": True}))["error"]["code"] == "not_found"
    finally:
        task.cancel()


async def test_mock_scene_and_edit_methods():
    hub = Hub(timeout=1)
    mock = Mock(hub)
    task = asyncio.create_task(mock.run())
    try:
        await asyncio.sleep(0.05)
        scenes = (await hub.request("scene.list", {}))["result"]["scenes"]
        assert len(scenes) == hub.state["scenes"]["count"] and scenes[0]["index"] == 0
        assert (await hub.request("scene.select", {"index": 99}))["error"]["code"] == "not_found"
        assert (await hub.request("scene.select", {"index": 5}))["result"] == {"index": 5}
        assert (await hub.request("scene.fire", {}))["result"] == {"index": 5}
        await asyncio.sleep(0.15)
        assert hub.state["scenes"]["fired"]["index"] == 5 and hub.state["scenes"]["selected"] == 6

        assert (await hub.request("loop.param.select", {"loop": 1, "parameter": 2}))["error"]["code"] == "unavailable"
        assert (await hub.request("edit.open", {"loop": 99}))["error"]["code"] == "not_found"
        assert (await hub.request("edit.open", {"loop": 1}))["result"] == {"loop": 1}
        await asyncio.sleep(0.15)
        assert hub.state["mode"] == "parameter_control" and hub.state["edit"]["name"] == "Drive"
        assert (await hub.request("loop.param.select", {"loop": 1, "parameter": 3}))["result"] == {"parameter": 3}
        assert (await hub.request("loop.param.select", {"loop": 1, "parameter": 9}))["error"]["code"] == "not_found"
        await asyncio.sleep(0.15)
        assert hub.state["edit"]["selected"] == 2
        assert (await hub.request("edit.close", {}))["result"] == {}
        await asyncio.sleep(0.15)
        assert hub.state["mode"] == "favorites" and "edit" not in hub.state
    finally:
        task.cancel()


async def test_mock_rename_methods():
    hub = Hub(timeout=1)
    mock = Mock(hub)
    task = asyncio.create_task(mock.run())
    try:
        await asyncio.sleep(0.05)
        assert (await hub.request("scene.rename", {"index": 1, "name": "Bridge"}))["result"] == {"index": 1, "name": "Bridge"}
        # Song A is on scenes 0 and 6: a rename moves both
        reply = await hub.request("preset.rename", {"scene_index": 0, "name": "Song Z"})
        assert reply["result"] == {"name": "Song Z", "linked": False}
        # Song B exists: scene 2 links to it
        reply = await hub.request("preset.rename", {"scene_index": 2, "name": "Song B"})
        assert reply["result"] == {"name": "Song B", "linked": True}
        assert (await hub.request("preset.rename", {"scene_index": 3, "name": "x"}))["error"]["code"] == "not_found"
        assert (await hub.request("preset.rename", {"scene_index": 0, "name": " "}))["error"]["code"] == "bad_params"
        scenes = (await hub.request("scene.list", {}))["result"]["scenes"]
        assert scenes[1]["name"] == "Bridge"
        assert [s["preset"] for s in scenes[:7]] == ["Song Z", "Song B", "Song B", None, "Song B", "Song C", "Song Z"]
        assert (await hub.request("preset.list", {}))["result"]["names"] == ["Song B", "Song C", "Song Z"]
    finally:
        task.cancel()
