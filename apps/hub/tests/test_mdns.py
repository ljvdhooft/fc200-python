import asyncio

from fc200_hub import mdns


class FakeZC:
    def __init__(self, ip):
        self.ip = ip
        self.closed = False

    async def async_close(self):
        self.closed = True


async def test_readvertises_when_ip_changes(monkeypatch):
    ips = iter(["172.20.10.3", "172.20.10.3", None, "172.20.10.5", "172.20.10.5"])
    registered = []

    async def register(port, ip):
        registered.append(FakeZC(ip))
        return registered[-1]

    monkeypatch.setattr(mdns, "_lan_ip", lambda: next(ips, "172.20.10.5"))
    monkeypatch.setattr(mdns, "_register", register)
    task = asyncio.create_task(mdns.advertise(20031, check_every=0.01))
    await asyncio.sleep(0.1)
    task.cancel()
    await asyncio.gather(task, return_exceptions=True)

    assert [z.ip for z in registered] == ["172.20.10.3", "172.20.10.5"]
    assert registered[0].closed  # dropped when the network went away
    assert registered[1].closed  # closed on cancel
