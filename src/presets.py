"""Preset files: a JSON shadow file per preset plus a dummy .alc clip.

<folder>/_json/<name>.json holds the loop states; <folder>/<name>.alc is a
dummy clip made from <folder>/template.alc.xml, so the preset can be dragged
in from Live's browser. The clip name is the preset name. No Live imports, so
it can be unit-tested.
"""

from __future__ import annotations

import gzip
import json
import os
from typing import NotRequired, TypedDict

from . import xmltodict

CLIP_COLOR = 69


class LoopState(TypedDict):
    parameters: list[float]
    chain: NotRequired[str]     # name of the selected chain


# Board device index -> state of that loop
Preset = dict[int, LoopState]


def json_path(folder: str, name: str) -> str:
    return os.path.join(folder, "_json", f"{name}.json")


def alc_path(folder: str, name: str) -> str:
    return os.path.join(folder, f"{name}.alc")


def exists(folder: str, name: str) -> bool:
    return os.path.exists(json_path(folder, name))


def save(folder: str, name: str, preset: Preset) -> None:
    path = json_path(folder, name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(json.dumps(preset, indent=2))


def load(folder: str, name: str) -> Preset | None:
    """Return the preset, or None if there is no file for it.

    Raises ValueError if the file is not a valid preset.
    """
    path = json_path(folder, name)
    if not os.path.exists(path):
        return None
    with open(path) as f:
        data = json.load(f)
    try:
        preset: Preset = {}
        for key, state in data.items():
            loop: LoopState = {"parameters": [float(v) for v in state["parameters"]]}
            if "chain" in state:
                loop["chain"] = str(state["chain"])
            preset[int(key)] = loop
        return preset
    except (AttributeError, KeyError, TypeError, ValueError) as e:
        raise ValueError(f"invalid preset {path}: {e!r}") from e


def alc_from_template(template_xml: str, name: str) -> str:
    """Return the template clip XML with the clip renamed and recolored."""
    template = xmltodict.parse(template_xml)
    clip = (template['Ableton']['LiveSet']['Tracks']['AudioTrack']['DeviceChain']
            ['MainSequencer']['ClipSlotList']['ClipSlot']['ClipSlot']['Value']['AudioClip'])
    clip['Name']['@Value'] = name
    clip['Color']['@Value'] = CLIP_COLOR
    return str(xmltodict.unparse(template))


def write_alc(folder: str, name: str) -> bool:
    """Write <name>.alc from template.alc.xml. Return False if there is no template."""
    template_path = os.path.join(folder, "template.alc.xml")
    if not os.path.exists(template_path):
        return False
    with open(template_path) as t:
        xml = alc_from_template(t.read(), name)
    with gzip.open(alc_path(folder, name), "wb") as f:
        f.write(xml.encode("utf-8"))
    return True
