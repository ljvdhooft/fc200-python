"""Advertise the hub as fc200.local (_http._tcp) via zeroconf."""

from __future__ import annotations

import logging
import socket

from zeroconf import IPVersion
from zeroconf.asyncio import AsyncServiceInfo, AsyncZeroconf

log = logging.getLogger(__name__)


def _lan_ip() -> str:
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        s.connect(("10.255.255.255", 1))  # no packet is sent
        return s.getsockname()[0]


async def advertise(port: int) -> AsyncZeroconf | None:
    try:
        zc = AsyncZeroconf(ip_version=IPVersion.V4Only)
        info = AsyncServiceInfo(
            "_http._tcp.local.", "FC200._http._tcp.local.", port=port,
            server="fc200.local.", addresses=[socket.inet_aton(_lan_ip())],
        )
        await zc.async_register_service(info)
        return zc
    except Exception:
        log.exception("mDNS advertisement failed; continuing without")
        return None
