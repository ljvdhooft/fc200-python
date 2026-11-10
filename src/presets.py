"""Presets: the state of the pedalboard loops, stored as files.

PresetManager is the entry point for every consumer (the FC-200, later a
frontend): it stores with overwrite confirmation, recalls by name and when a
clip starts playing, and reports what happened as PresetEvents. It knows
nothing about the hardware; see protocol/presets.md.

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

from . import xmltodict

if TYPE_CHECKING:
    from Live.Chain import Chain
    from Live.RackDevice import RackDevice
    from Live.Track import Track

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

    def names(self) -> list[str]:
        """Names of all stored presets, sorted."""
        folder = os.path.join(self.folder, "_json")
        if not os.path.isdir(folder):
            return []
        return sorted(f[:-len(".json")] for f in os.listdir(folder) if f.endswith(".json"))

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


class PresetEvents:
    """What a PresetManager reports. Subclass and override what you need;
    the defaults do nothing. See protocol/presets.md."""

    def overwrite_pending(self, name: str) -> None:
        """store() found an existing preset: store again to overwrite, or cancel()."""

    def overwrite_cancelled(self, name: str) -> None:
        """A pending overwrite was cancelled."""

    def saved(self, name: str) -> None:
        """The preset was written."""

    def save_failed(self, name: str) -> None:
        """Writing the preset failed (details are logged)."""

    def recalled(self, name: str) -> None:
        """The preset was applied to the board."""

    def template_clip_copied(self, scene_index: int) -> None:
        """The selected slot was empty and got a copy of the dummy clip in slot 0.
        Rename it, then store again."""

    def template_clip_missing(self) -> None:
        """The selected slot was empty and there is no dummy clip in slot 0 to copy."""


class PresetManager:
    """Store and recall presets for the pedalboard. Consumers call the methods
    and subscribe() to PresetEvents; nothing here knows about the hardware.

    Store: the preset is named after the clip on the selected scene. An empty
    slot gets a copy of the dummy clip in slot 0 (rename it, then store again).
    Overwriting an existing preset takes a second store() for the same name,
    or cancel().

    Recall: by name with recall(), and automatically when a clip starts playing
    on the pedalboard track (the preset with the clip's name).
    """

    def __init__(self, store: PresetStore, track: Track, board: Chain, loops: Sequence[int],
                 defer: Callable[[Callable[[], None]], object]) -> None:
        """loops: board device indices to store. defer: runs a function on Live's next tick."""
        self._store = store
        self._track = track
        self._board = board
        self._loops = loops
        self._defer = defer
        self._listeners: list[PresetEvents] = []
        self._pending_overwrite: str | None = None
        track.add_playing_slot_index_listener(self._on_playing_slot_changed)

    def subscribe(self, listener: PresetEvents) -> None:
        self._listeners.append(listener)

    def unsubscribe(self, listener: PresetEvents) -> None:
        self._listeners.remove(listener)

    def disconnect(self) -> None:
        self.cancel()
        if self._track.playing_slot_index_has_listener(self._on_playing_slot_changed):
            self._track.remove_playing_slot_index_listener(self._on_playing_slot_changed)

    @property
    def pending_overwrite(self) -> str | None:
        """Name of the preset waiting for overwrite confirmation, if any."""
        return self._pending_overwrite

    def preset_names(self) -> list[str]:
        return self._store.names()

    def store(self, scene_index: int) -> None:
        """Store the board as the preset named after the clip on this scene."""
        slot = self._track.clip_slots[scene_index]
        if not slot.has_clip:
            template = self._track.clip_slots[0]
            if not template.has_clip:
                for listener in self._listeners:
                    listener.template_clip_missing()
                return
            template.duplicate_clip_to(slot)
            for listener in self._listeners:
                listener.template_clip_copied(scene_index)
            return
        name = slot.clip.name

        if self._store.exists(name) and self._pending_overwrite != name:
            self.cancel()
            self._pending_overwrite = name
            for listener in self._listeners:
                listener.overwrite_pending(name)
            return

        self._pending_overwrite = None
        saved = self._store.save(name, Preset.read(self._board, self._loops))
        for listener in self._listeners:
            if saved:
                listener.saved(name)
            else:
                listener.save_failed(name)

    def cancel(self) -> bool:
        """Cancel a pending overwrite. Return True if one was pending."""
        name = self._pending_overwrite
        if name is None:
            return False
        self._pending_overwrite = None
        for listener in self._listeners:
            listener.overwrite_cancelled(name)
        return True

    def recall(self, name: str) -> bool:
        """Apply the preset on Live's next tick. Return False if there is no such preset."""
        preset = self._store.load(name)
        if preset is None:
            return False

        def apply() -> None:
            preset.apply(self._board)
            for listener in self._listeners:
                listener.recalled(name)
        # Live rejects changes made from inside a listener, so never apply directly
        self._defer(apply)
        return True

    def _on_playing_slot_changed(self) -> None:
        index = self._track.playing_slot_index
        if index >= 0:
            self.recall(self._track.clip_slots[index].clip.name)


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
