import asyncio

from fc200_hub.__main__ import exit_when_idle
from fc200_hub.hub import Hub


async def test_exits_after_the_grace_period_without_live():
    stop = asyncio.Event()
    await asyncio.wait_for(exit_when_idle(Hub(), 0.03, stop, poll=0.01), 1)
    assert stop.is_set()


async def test_live_connection_resets_the_countdown():
    hub, stop = Hub(), asyncio.Event()
    task = asyncio.create_task(exit_when_idle(hub, 0.05, stop, poll=0.01))
    for _ in range(4):  # 0.12 s in total, but Live comes back every 0.03 s
        await asyncio.sleep(0.02)
        hub.live_connected = True
        await asyncio.sleep(0.01)
        hub.live_connected = False
    assert not stop.is_set()
    await asyncio.wait_for(task, 1)
    assert stop.is_set()
