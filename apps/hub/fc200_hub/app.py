from __future__ import annotations

import asyncio
from pathlib import Path

from aiohttp import web

from .hub import Hub
from .live_link import LiveLink
from .mock import Mock

TASK = web.AppKey("backend_task", asyncio.Task)
DIST = Path(__file__).resolve().parents[2] / "web" / "dist"
PLACEHOLDER = (
    "<!doctype html><meta charset=utf-8><meta name=viewport content='width=device-width'>"
    "<title>FC200 hub</title><body style='font-family:sans-serif;background:#111;color:#eee'>"
    "<h1>FC200 hub</h1><p>Web app not built yet (apps/web/dist missing). WebSocket: /ws</p>"
)


def make_app(hub: Hub, dist: Path = DIST) -> web.Application:
    app = web.Application()
    app.router.add_get("/ws", hub.handle_ws)
    if (dist / "index.html").is_file():
        async def index(_: web.Request) -> web.FileResponse:
            return web.FileResponse(dist / "index.html")
        app.router.add_get("/", index)
        app.router.add_static("/", dist)
    else:
        async def placeholder(_: web.Request) -> web.Response:
            return web.Response(text=PLACEHOLDER, content_type="text/html")
        app.router.add_get("/", placeholder)
    return app


def attach_backend(app: web.Application, backend: LiveLink | Mock) -> None:
    async def start(app: web.Application) -> None:
        app[TASK] = asyncio.create_task(backend.run())

    async def stop(app: web.Application) -> None:
        app[TASK].cancel()

    app.on_startup.append(start)
    app.on_cleanup.append(stop)
