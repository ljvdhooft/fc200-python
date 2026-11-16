from __future__ import annotations

import argparse
import asyncio
import logging
import signal

from aiohttp import web

from .app import attach_backend, make_app
from .hub import Hub
from .live_link import LiveLink
from .mdns import advertise
from .mock import Mock


async def exit_when_idle(hub: Hub, grace: float, stop: asyncio.Event, poll: float = 5.0) -> None:
    """Set `stop` once Live has been disconnected for `grace` seconds (also right after start)."""
    idle = 0.0
    while not stop.is_set():
        await asyncio.sleep(poll)
        idle = 0.0 if hub.live_connected else idle + poll
        if idle >= grace:
            logging.info("Live gone for %ss: exiting", grace)
            stop.set()


async def serve(args: argparse.Namespace) -> None:
    hub = Hub()
    backend = Mock(hub) if args.mock else LiveLink(hub, port=args.live_port)
    app = make_app(hub)
    attach_backend(app, backend)
    runner = web.AppRunner(app)
    await runner.setup()
    await web.TCPSite(runner, "0.0.0.0", args.port).start()
    logging.info("hub on :%s (%s)", args.port, "mock" if args.mock else "live")
    mdns = None if args.no_mdns else asyncio.create_task(advertise(args.port))
    # SIGTERM (the launcher's Stop) and the idle exit are clean exits, so launchd
    # doesn't restart the hub
    stop = asyncio.Event()
    asyncio.get_running_loop().add_signal_handler(signal.SIGTERM, stop.set)
    idle = asyncio.create_task(exit_when_idle(hub, args.idle_exit, stop)) if args.idle_exit else None
    try:
        await stop.wait()
    finally:
        if mdns:
            mdns.cancel()
        if idle:
            idle.cancel()
        await runner.cleanup()


def main() -> None:
    parser = argparse.ArgumentParser(prog="fc200_hub")
    parser.add_argument("--mock", action="store_true", help="scripted fake state instead of Live")
    parser.add_argument("--port", type=int, default=20031)
    parser.add_argument("--live-port", type=int, default=20030)
    parser.add_argument("--no-mdns", action="store_true")
    parser.add_argument("--idle-exit", type=float, metavar="SECONDS",
                        help="exit cleanly once Live has been gone this long")
    args = parser.parse_args()
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    try:
        asyncio.run(serve(args))
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
