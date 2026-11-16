"""When the tuner shows, on the bank display and in the frontend.

No Live imports: tested with a fake timer (tests/test_tuner.py).
"""

from __future__ import annotations

from collections.abc import Callable
from typing import Protocol


class Killable(Protocol):
    def kill(self) -> None: ...


class TunerGate:
    """The tuner shows while the volume is 0 and a note sounds (the tuner's `level`
    above `threshold`), and for `hold` seconds after the note stops, so a short gap
    between notes doesn't flicker. Leaving volume 0 hides it at once.

    `after(seconds, fn)` schedules fn and returns something killable;
    `on_change(active)` is called whenever `active` flips.
    """

    def __init__(self, threshold: float, hold: float,
                 after: Callable[[float, Callable[[], None]], Killable],
                 on_change: Callable[[bool], None]) -> None:
        self.threshold = threshold
        self.hold = hold
        self.active = False
        self._after = after
        self._on_change = on_change
        self._pending: Killable | None = None

    def update(self, volume: float, level: float) -> None:
        if volume > 0:
            self._cancel()
            self._set(False)
        elif level > self.threshold:
            self._cancel()
            self._set(True)
        elif self.active and self._pending is None:
            self._pending = self._after(self.hold, self._expire)

    def _expire(self) -> None:
        self._pending = None
        self._set(False)

    def _cancel(self) -> None:
        if self._pending is not None:
            self._pending.kill()
            self._pending = None

    def _set(self, active: bool) -> None:
        if active != self.active:
            self.active = active
            self._on_change(active)
