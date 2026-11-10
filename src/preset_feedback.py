"""Shows preset events on the FC-200 and in Live's status bar."""

from __future__ import annotations

from collections.abc import Callable
from typing import TYPE_CHECKING

from . import presets
from . import roland_exclusive as se

if TYPE_CHECKING:
    from _Framework.Task import Task

    from .hardware import FC200Hardware


class PresetFeedback(presets.PresetEvents):
    """The store pedal blinks while an overwrite awaits confirmation and
    flashes when saved; messages go to Live's status bar."""

    def __init__(self, hw: FC200Hardware, pedal: se.Pedal, show_message: Callable[[str], None],
                 page: Callable[[], int], store_page: int) -> None:
        """page: returns the current page. store_page: the page the store pedal is on;
        its LED is only touched there."""
        self._hw = hw
        self._pedal = pedal
        self._show_message = show_message
        self._page = page
        self._store_page = store_page
        self._blink: Task | None = None

    def overwrite_pending(self, name: str) -> None:
        self._stop_blink()
        self._blink = self._hw.blink_loop(self._pedal, 0.3)
        self._show_message(f"Overwrite preset {name}?")

    def overwrite_cancelled(self, name: str) -> None:
        self._stop_blink()
        self._show_message("Cancelled saving preset!")
        if self._page() == self._store_page:
            self._hw.led(self._pedal, se.OFF)

    def saved(self, name: str) -> None:
        self._stop_blink()
        self._show_message(f"Saved preset: {name}")
        self._hw.flash_repeatedly(self._pedal, 3)

    def save_failed(self, name: str) -> None:
        self._stop_blink()
        self._show_message(f"Could not save preset {name}")

    def template_clip_missing(self) -> None:
        self._show_message('No clip on selected slot')

    def _stop_blink(self) -> None:
        if self._blink is not None:
            self._blink.kill()
            self._blink = None
