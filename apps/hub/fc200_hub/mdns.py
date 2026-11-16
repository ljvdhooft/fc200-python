"""Advertise the hub as fc200.local (_http._tcp) via zeroconf.

The LAN IP can change when the hotspot drops and comes back, so it is re-checked
every few seconds; on a change the advertisement is redone from scratch (a fresh
Zeroconf instance also rejoins multicast on the new network).
"""

from __future__ import annotations

import asyncio
import logging
import socket

from zeroconf import IPVersion
from zeroconf.asyncio import AsyncServiceInfo, AsyncZeroconf

log = logging.getLogger(__name__)

CHECK_EVERY = 5.0  # seconds


def _lan_ip() -> str | None:
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
            s.connect(("10.255.255.255", 1))  # no packet is sent
            return s.getsockname()[0]
    except OSError:
        return None  # no network


async def _register(port: int, ip: str) -> AsyncZeroconf | None:
    try:
        zc = AsyncZeroconf(ip_version=IPVersion.V4Only)
        info = AsyncServiceInfo(
            "_http._tcp.local.", "FC200._http._tcp.local.", port=port,
            server="fc200.local.", addresses=[socket.inet_aton(ip)],
        )
        await zc.async_register_service(info)
        log.info("mDNS: fc200.local -> %s", ip)
        return zc
    except Exception:
        log.exception("mDNS advertisement failed; retrying on the next check")
        return None


async def advertise(port: int, check_every: float = CHECK_EVERY) -> None:
    """Keep fc200.local pointing at the current LAN IP until cancelled."""
    zc: AsyncZeroconf | None = None
    current: str | None = None
    try:
        while True:
            ip = _lan_ip()
            if ip != current or (ip and zc is None):
                if zc:
                    await zc.async_close()
                    zc = None
                current = ip
                if ip is None:
                    log.info("mDNS: no network, waiting")
                else:
                    zc = await _register(port, ip)
            await asyncio.sleep(check_every)
    finally:
        if zc:
            await zc.async_close()
