"""Starts the frontend hub's launchd agent with the script.

No Live imports. The agent (apps/hub/launchd/nl.fc200.hub.plist) doesn't run at
login; the script kickstarts it on load. The hub exits by itself 10 minutes after
Live is gone (--idle-exit), which also covers Live crashing; launchd only restarts
it after a crash. The script starts the agent the agent only when the
installed agent runs the hub from this script's own checkout, so a development
checkout loaded in Live leaves the installed (production) hub alone.
"""

from __future__ import annotations

import os
import plistlib
import subprocess
from collections.abc import Callable

LABEL = "nl.fc200.hub"
PLIST = os.path.expanduser(f"~/Library/LaunchAgents/{LABEL}.plist")
# src/ is symlinked into the User Library; realpath leads back to the checkout
CHECKOUT = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))


def installed_hub_dir(plist_path: str) -> str | None:
    """The hub directory the installed agent runs from, or None when not installed."""
    try:
        with open(plist_path, "rb") as f:
            return plistlib.load(f).get("WorkingDirectory")
    except (OSError, plistlib.InvalidFileException):
        return None


class HubService:
    def __init__(self, log: Callable[[str], None], checkout: str = CHECKOUT, plist_path: str = PLIST,
                 run: Callable[[list[str]], int] | None = None) -> None:
        self._log = log
        self._run = run or _launchctl
        hub_dir = installed_hub_dir(plist_path)
        own_hub = os.path.realpath(os.path.join(checkout, "apps", "hub"))
        self.enabled = hub_dir is not None and os.path.realpath(hub_dir) == own_hub
        if hub_dir is None:
            log("Hub: no launchd agent installed; start the hub yourself")
        elif not self.enabled:
            log(f"Hub: the launchd agent runs {hub_dir}, not this checkout; leaving it alone")

    def start(self) -> None:
        if self.enabled:
            self._call(["kickstart", f"gui/{os.getuid()}/{LABEL}"], "started")

    def _call(self, args: list[str], done: str) -> None:
        code = self._run(args)
        self._log(f"Hub: {done}" if code == 0 else f"Hub: launchctl {args[0]} failed ({code})")


def _launchctl(args: list[str]) -> int:
    # Called on load only; launchctl returns within milliseconds
    try:
        return subprocess.run(["/bin/launchctl", *args], capture_output=True, timeout=5).returncode
    except (OSError, subprocess.TimeoutExpired):
        return -1
