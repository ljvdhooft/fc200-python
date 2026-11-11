import asyncio
import json
from pathlib import Path

import pytest
from aiohttp.test_utils import TestClient, TestServer

from fc200_hub import ui_protocol as proto
from fc200_hub.app import attach_backend, make_app
from fc200_hub.hub import Hub

SNAPSHOT = json.loads((Path(__file__).resolve().parents[3] / "protocol/fixtures/snapshot.json").read_text())


class FakeBackend:
    """Records requests; tests answer them by hand."""

    def __init__(self, hub: Hub) -> None:
        self.hub = hub
        hub.backend = self
        self.sent: list[proto.Message] = []

    def send(self, message):
        self.sent.append(message)
        return True

    async def run(self):
        await asyncio.Event().wait()


@pytest.fixture
async def env(aiohttp_client):
    hub = Hub(timeout=0.3)
    backend = FakeBackend(hub)
    app = make_app(hub)
    client = await aiohttp_client(app)
    return hub, backend, client


async def recv(ws):
    return json.loads((await asyncio.wait_for(ws.receive_str(), 2)))
