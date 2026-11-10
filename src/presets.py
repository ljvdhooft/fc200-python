"""Presets: the state of the pedalboard loops, stored as files.

PresetManager is what the script uses: it stores on a pedal press (with
overwrite confirmation) and recalls when a clip starts playing.

A PresetStore keeps <folder>/_json/<name>.json per preset, plus a dummy clip
<folder>/<name>.alc made from <folder>/template.alc.xml, so the preset can be
dragged in from Live's browser. The clip name is the preset name.

No Live imports at runtime (Live types are type-only), so it can be
unit-tested with fake board objects.
"""

from __future__ import annotations

import gzip
import json
import os
from collections.abc import Callable, Iterable, Sequence
from dataclasses import dataclass, field
from typing import TYPE_CHECKING, NotRequired, TypedDict, cast

from . import roland_exclusive as se
from . import xmltodict

if TYPE_CHECKING:
    from _Framework.Task import Task
    from Live.Chain import Chain
    from Live.RackDevice import RackDevice
    from Live.Track import Track

    from .hardware import FC200Hardware

CLIP_COLOR = 69
PARAMETER_COUNT = 8     # parameters stored per loop


class LoopState(TypedDict):
    parameters: list[float]
    chain: NotRequired[str]     # name of the selected chain


@dataclass
class Preset:
    """Board device index -> state of that loop."""
    loops: dict[int, LoopState] = field(default_factory=dict)

    @classmethod
    def read(cls, board: Chain, indices: Iterable[int]) -> Preset:
        """Read the first parameters and selected chain of each loop on the board."""
        loops: dict[int, LoopState] = {}
        for index in indices:
            loop = _rack(board, index)
            loops[index] = {
                "parameters": [loop.parameters[i].value for i in range(PARAMETER_COUNT)],
                "chain": loop.view.selected_chain.name,
            }
        return cls(loops)

    def apply(self, board: Chain) -> None:
        """Set the stored values on the board; disabled parameters are skipped."""
        for index, state in self.loops.items():
            loop = _rack(board, index)
            for i, value in enumerate(state["parameters"]):
                parameter = loop.parameters[i]
                if parameter.is_enabled:
                    parameter.value = value
            if "chain" in state:
                for chain in loop.chains:
                    if chain.name == state["chain"]:
                        loop.view.selected_chain = chain
                        break

    def to_json(self) -> str:
        return json.dumps(self.loops, indent=2)

    @classmethod
    def from_json(cls, text: str) -> Preset:
        """Raises ValueError if text is not a valid preset."""
        data = json.loads(text)
        try:
            loops: dict[int, LoopState] = {}
            for key, state in data.items():
                loop: LoopState = {"parameters": [float(v) for v in state["parameters"]]}
                if "chain" in state:
                    loop["chain"] = str(state["chain"])
                loops[int(key)] = loop
            return cls(loops)
        except (AttributeError, KeyError, TypeError, ValueError) as e:
            raise ValueError(f"invalid preset: {e!r}") from e


class PresetStore:
    """Preset files in one folder. File errors are logged, not raised."""

    def __init__(self, folder: str, log: Callable[[str], None]) -> None:
        self.folder = folder
        self._log = log
        if not os.path.isdir(folder):
            log(f"Preset folder not found, it is created on the first save: {folder}")

    def json_path(self, name: str) -> str:
        return os.path.join(self.folder, "_json", f"{name}.json")

    def alc_path(self, name: str) -> str:
        return os.path.join(self.folder, f"{name}.alc")

    def exists(self, name: str) -> bool:
        return os.path.exists(self.json_path(name))

    def save(self, name: str, preset: Preset) -> bool:
        """Write the JSON file and the .alc clip. Return False if that failed (logged)."""
        path = self.json_path(name)
        try:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, "w") as f:
                f.write(preset.to_json())
            self._write_alc(name)
        except OSError as e:
            self._log(f"Error saving preset {name}: {e}")
            return False
        return True

    def load(self, name: str) -> Preset | None:
        """Return the preset; None if there is no file for it, or it can't be read (logged)."""
        path = self.json_path(name)
        if not os.path.exists(path):
            return None
        try:
            with open(path) as f:
                return Preset.from_json(f.read())
        except (OSError, ValueError) as e:
            self._log(f"Error reading preset {path}: {e}")
            return None

    def _write_alc(self, name: str) -> None:
        """Write <name>.alc from template.alc.xml; skipped if there is no template."""
        template_path = os.path.join(self.folder, "template.alc.xml")
        if not os.path.exists(template_path):
            return
        with open(template_path) as t:
            xml = alc_from_template(t.read(), name)
        with gzip.open(self.alc_path(name), "wb") as f:
            f.write(xml.encode("utf-8"))


class PresetManager:
    """Store and recall presets for the pedalboard; the script only forwards events.

    Store: the preset is named after the clip on the selected scene. An empty
    slot gets a copy of the dummy clip in slot 0 (rename it, then store again).
    Overwriting an existing preset takes a second press; the store pedal
    blinks until then, or until cancel().

    Recall: when a clip starts playing on the pedalboard track, the preset with
    the clip's name is applied to the board.
    """

    def __init__(self, store: PresetStore, track: Track, board: Chain, loops: Sequence[int],
                 hw: FC200Hardware, pedal: se.Pedal, show_message: Callable[[str], None],
                 defer: Callable[[Callable[[], None]], object]) -> None:
        """loops: board device indices to store. pedal: the store pedal (LED feedback).
        defer: runs a function on Live's next tick."""
        self._store = store
        self._track = track
        self._board = board
        self._loops = loops
        self._hw = hw
        self._pedal = pedal
        self._show_message = show_message
        self._defer = defer
        self._overwrite_blink: Task | None = None
        track.add_playing_slot_index_listener(self._on_playing_slot_changed)

    def disconnect(self) -> None:
        self.cancel()
        if self._track.playing_slot_index_has_listener(self._on_playing_slot_changed):
            self._track.remove_playing_slot_index_listener(self._on_playing_slot_changed)

    def store(self, scene_index: int) -> None:
        """The store pedal was pressed with this scene selected."""
        slot = self._track.clip_slots[scene_index]
        if not slot.has_clip:
            template = self._track.clip_slots[0]
            if not template.has_clip:
                self._show_message('No clip on selected slot')
                return
            template.duplicate_clip_to(slot)
            return
        name = slot.clip.name

        if self._store.exists(name) and self._overwrite_blink is None:
            self._overwrite_blink = self._hw.blink_loop(self._pedal, 0.3)
            self._show_message(f"Overwrite preset {name}?")
            return

        self.cancel()
        if self._store.save(name, Preset.read(self._board, self._loops)):
            self._show_message(f"Saved preset: {name}")
            self._hw.flash_repeatedly(self._pedal, 3)

    def cancel(self, announce: bool = False) -> bool:
        """Stop a pending overwrite confirmation. Return True if one was pending.

        announce: tell the user, and turn the store pedal LED off.
        """
        if self._overwrite_blink is None:
            return False
        self._overwrite_blink.kill()
        self._overwrite_blink = None
        if announce:
            self._show_message("Cancelled saving preset!")
            self._hw.led(self._pedal, se.OFF)
        return True

    def _on_playing_slot_changed(self) -> None:
        index = self._track.playing_slot_index
        if index < 0:
            return
        preset = self._store.load(self._track.clip_slots[index].clip.name)
        if preset is not None:
            # Live rejects changes made from inside a listener: apply on the next tick
            self._defer(lambda: preset.apply(self._board))


def alc_from_template(template_xml: str, name: str) -> str:
    """Return the template clip XML with the clip renamed and recolored."""
    template = xmltodict.parse(template_xml)
    clip = (template['Ableton']['LiveSet']['Tracks']['AudioTrack']['DeviceChain']
            ['MainSequencer']['ClipSlotList']['ClipSlot']['ClipSlot']['Value']['AudioClip'])
    clip['Name']['@Value'] = name
    clip['Color']['@Value'] = CLIP_COLOR
    return str(xmltodict.unparse(template))


def _rack(board: Chain, index: int) -> RackDevice:
    """A loop on the board. Loops are racks."""
    return cast("RackDevice", board.devices[index])
