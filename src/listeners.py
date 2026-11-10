"""Bookkeeping for Live listeners.

Live's objects all follow one naming scheme for listeners on a property:
add_<prop>_listener, remove_<prop>_listener, <prop>_has_listener. Listeners
added through a Listeners registry are removed together by remove_all(), so
setup, reload and disconnect stay symmetric.

Callbacks are wrapped: an exception in a listener would otherwise go to
Log.txt without context and can disable the listener, so it is logged with
a traceback instead. No Live imports, so it can be unit-tested.
"""

from __future__ import annotations

import traceback
from collections.abc import Callable


class Listeners:
    def __init__(self, log: Callable[[str], None]) -> None:
        self._log = log
        self._removers: list[Callable[[], None]] = []

    def add(self, subject: object, prop: str, callback: Callable[[], None]) -> None:
        """Call callback when subject.<prop> changes, until remove_all()."""
        def guarded() -> None:
            try:
                callback()
            except Exception:
                self._log(f"Error in {prop} listener:\n{traceback.format_exc()}")

        getattr(subject, f"add_{prop}_listener")(guarded)

        def remove() -> None:
            if getattr(subject, f"{prop}_has_listener")(guarded):
                getattr(subject, f"remove_{prop}_listener")(guarded)
        self._removers.append(remove)

    def remove_all(self) -> None:
        for remove in reversed(self._removers):
            remove()
        self._removers.clear()

    def __len__(self) -> int:
        return len(self._removers)
