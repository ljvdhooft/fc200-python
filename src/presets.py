"""Presets: the state of the pedalboard loops, stored as files.

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
from collections.abc import Iterable
from dataclasses import dataclass, field
from typing import TYPE_CHECKING, NotRequired, TypedDict, cast

from . import xmltodict

if TYPE_CHECKING:
    from Live.Chain import Chain
    from Live.RackDevice import RackDevice

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
    """Preset files in one folder."""

    def __init__(self, folder: str) -> None:
        self.folder = folder

    def available(self) -> bool:
        return os.path.isdir(self.folder)

    def json_path(self, name: str) -> str:
        return os.path.join(self.folder, "_json", f"{name}.json")

    def alc_path(self, name: str) -> str:
        return os.path.join(self.folder, f"{name}.alc")

    def exists(self, name: str) -> bool:
        return os.path.exists(self.json_path(name))

    def save(self, name: str, preset: Preset) -> None:
        path = self.json_path(name)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w") as f:
            f.write(preset.to_json())

    def load(self, name: str) -> Preset | None:
        """Return the preset, or None if there is no file for it.

        Raises ValueError if the file is not a valid preset.
        """
        path = self.json_path(name)
        if not os.path.exists(path):
            return None
        with open(path) as f:
            try:
                return Preset.from_json(f.read())
            except ValueError as e:
                raise ValueError(f"{path}: {e}") from e

    def write_alc(self, name: str) -> bool:
        """Write <name>.alc from template.alc.xml. Return False if there is no template."""
        template_path = os.path.join(self.folder, "template.alc.xml")
        if not os.path.exists(template_path):
            return False
        with open(template_path) as t:
            xml = alc_from_template(t.read(), name)
        with gzip.open(self.alc_path(name), "wb") as f:
            f.write(xml.encode("utf-8"))
        return True


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
