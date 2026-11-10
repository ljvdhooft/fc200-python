from collections.abc import Sequence

from . import Listener
from .ClipSlot import ClipSlot
from .Device import Device

class Track:
    name: str
    devices: Sequence[Device]
    clip_slots: Sequence[ClipSlot]
    playing_slot_index: int  # -1 when nothing plays

    def add_playing_slot_index_listener(self, listener: Listener) -> None: ...
    def remove_playing_slot_index_listener(self, listener: Listener) -> None: ...
    def playing_slot_index_has_listener(self, listener: Listener) -> bool: ...
