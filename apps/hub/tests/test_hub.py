import asyncio
import copy

from conftest import SNAPSHOT, recv


async def test_snapshot_then_status_on_connect(env):
    hub, _, client = env
    hub.set_live(True)
    hub.on_snapshot(SNAPSHOT)
    ws = await client.ws_connect("/ws")
    snap = await recv(ws)
    assert snap["event"] == "state.snapshot"
    assert snap["data"]["hub"] == {"live_connected": True}
    assert snap["data"]["loops"] == SNAPSHOT["loops"]
    assert await recv(ws) == {"event": "hub.status", "data": {"live_connected": True}}


async def test_no_snapshot_means_status_only(env):
    _, _, client = env
    ws = await client.ws_connect("/ws")
    assert await recv(ws) == {"event": "hub.status", "data": {"live_connected": False}}


async def test_patch_updates_cache_and_fans_out(env):
    hub, _, client = env
    hub.set_live(True)
    hub.on_snapshot(SNAPSHOT)
    a, b = await client.ws_connect("/ws"), await client.ws_connect("/ws")
    for ws in (a, b):
        await recv(ws), await recv(ws)
    hub.on_patch({"tempo": 99.0, "loops.0.on": False})
    for ws in (a, b):
        assert await recv(ws) == {"event": "state.patch", "data": {"tempo": 99.0, "loops.0.on": False}}
    assert hub.state["tempo"] == 99.0 and hub.state["loops"][0]["on"] is False
    late = await client.ws_connect("/ws")
    assert (await recv(late))["data"]["tempo"] == 99.0


async def test_bad_patch_is_ignored(env):
    hub, _, _ = env
    hub.on_snapshot(copy.deepcopy(SNAPSHOT))
    hub.on_patch({"loops.99.on": True})
    assert hub.state["tempo"] == SNAPSHOT["tempo"]


async def test_request_ids_rewritten_and_routed_back(env):
    hub, backend, client = env
    hub.set_live(True)
    a, b = await client.ws_connect("/ws"), await client.ws_connect("/ws")
    for ws in (a, b):
        await recv(ws)
    await a.send_json({"id": "x", "method": "loop.set", "params": {"loop": 0, "on": True}})
    await b.send_json({"id": "x", "method": "page.set", "params": {"page": 1}})
    while len(backend.sent) < 2:
        await asyncio.sleep(0.01)
    first, second = backend.sent
    assert first["id"] != second["id"] and first["id"] != "x"
    # answer in reverse order
    hub.on_response({"id": second["id"], "result": {"page": 1}})
    hub.on_response({"id": first["id"], "result": {"on": True}})
    assert await recv(b) == {"id": "x", "result": {"page": 1}}
    assert await recv(a) == {"id": "x", "result": {"on": True}}


async def test_request_times_out(env):
    hub, _, client = env
    hub.set_live(True)
    ws = await client.ws_connect("/ws")
    await recv(ws)
    await ws.send_json({"id": 7, "method": "param.set", "params": {}})
    reply = await recv(ws)
    assert reply["id"] == 7 and reply["error"]["code"] == "timeout"


async def test_request_when_offline(env):
    _, _, client = env
    ws = await client.ws_connect("/ws")
    await recv(ws)
    await ws.send_json({"id": 1, "method": "page.set", "params": {"page": 0}})
    reply = await recv(ws)
    assert reply["id"] == 1 and reply["error"]["code"] == "live_offline"


async def test_pending_request_fails_when_link_drops(env):
    hub, backend, client = env
    hub.set_live(True)
    ws = await client.ws_connect("/ws")
    await recv(ws)
    await ws.send_json({"id": 1, "method": "page.set", "params": {"page": 0}})
    while not backend.sent:
        await asyncio.sleep(0.01)
    hub.set_live(False)
    while True:
        msg = await recv(ws)
        if "id" in msg:
            break
    assert msg["error"]["code"] == "live_offline" and msg["id"] == 1


async def test_bad_json_gets_error(env):
    _, _, client = env
    ws = await client.ws_connect("/ws")
    await recv(ws)
    await ws.send_str("not json")
    assert (await recv(ws))["error"]["code"] == "bad_params"


async def test_events_forwarded(env):
    hub, _, client = env
    ws = await client.ws_connect("/ws")
    await recv(ws)
    hub.on_event({"event": "preset.saved", "data": {"name": "x"}})
    assert (await recv(ws))["event"] == "preset.saved"


async def test_placeholder_page(env):
    _, _, client = env
    resp = await client.get("/")
    assert resp.status == 200 and "FC200 hub" in await resp.text()
