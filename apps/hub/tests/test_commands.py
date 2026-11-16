import asyncio

from fc200_hub import ui_protocol as proto
from fc200_hub.hub import Hub
from fc200_hub.live_link import LiveLink
from fc200_hub.midi_out import is_channel_message

from conftest import DUMP, recv
from test_live_link import FakeScript, until


async def test_command_runs_and_is_not_forwarded(env):
    hub, _, client = env
    sent = []
    hub.commands["midi.send"] = lambda params: sent.append(params["bytes"])
    hub.set_live(True)
    ws = await client.ws_connect("/ws")
    await recv(ws)  # hub.status
    hub.on_command(proto.command("midi.send", {"bytes": [207, 1]}))
    hub.on_event(proto.event("scene.fired", {"index": 0}))
    assert sent == [[207, 1]]
    # the next thing the client sees is the event, not the command
    assert (await recv(ws))["event"] == "scene.fired"


async def test_unknown_or_failing_command_is_ignored():
    hub = Hub()
    hub.on_command(proto.command("nope"))

    def fail(params):
        raise OSError("no CoreMIDI")
    hub.commands["midi.send"] = fail
    hub.on_command(proto.command("midi.send", {"bytes": [207, 1]}))


async def test_live_link_routes_commands():
    script = FakeScript()
    port = await script.start()
    hub = Hub(timeout=1)
    sent = []
    hub.commands["midi.send"] = lambda params: sent.append(params["bytes"])
    task = asyncio.create_task(LiveLink(hub, port=port, backoff_min=0.05).run())
    try:
        await until(lambda: hub.live_connected and hub.state)
        script.writers[0].write(proto.encode(proto.command("midi.send", {"bytes": [207, 1]})))
        await until(lambda: sent)
        assert sent == [[207, 1]]
        assert hub.state["loops"] == DUMP["loops"]
    finally:
        task.cancel()
        await script.stop()


def test_is_channel_message():
    for good in ([207, 1], [0x90, 60, 127], [0xB0, 0, 0], [0xE0, 0, 64]):
        assert is_channel_message(good), good
    for bad in ([], [207], [207, 1, 2], [0x90, 60], [0xF0, 1, 0xF7], [0x3C, 1],
                [207, 128], [207, True], [207, 1.0], "abc", None, 207):
        assert not is_channel_message(bad), bad
