from __future__ import annotations

import argparse
import asyncio
import logging

from aiohttp import web

from .app import attach_backend, make_app
from .hub import Hub
from .live_link import LiveLink
from .mdns import advertise
from .mock import Mock


async def serve(args: argparse.Namespace) -> None:
    hub = Hub()
    backend = Mock(hub) if args.mock else LiveLink(hub, port=args.live_port)
    app = make_app(hub)
    attach_backend(app, backend)
    runner = web.AppRunner(app)
    await runner.setup()
    await web.TCPSite(runner, "0.0.0.0", args.port).start()
    logging.info("hub on :%s (%s)", args.port, "mock" if args.mock else "live")
    zc = None if args.no_mdns else await advertise(args.port)
    try:
        await asyncio.Event().wait()
    finally:
        if zc:
            await zc.async_close()
        await runner.cleanup()


def main() -> None:
    parser = argparse.ArgumentParser(prog="fc200_hub")
    parser.add_argument("--mock", action="store_true", help="scripted fake state instead of Live")
    parser.add_argument("--port", type=int, default=20031)
    parser.add_argument("--live-port", type=int, default=20030)
    parser.add_argument("--no-mdns", action="store_true")
    args = parser.parse_args()
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    try:
        asyncio.run(serve(args))
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
