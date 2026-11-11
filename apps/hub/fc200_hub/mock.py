"""Scripted stand-in for the Live link (--mock).

The ONLY module that knows concrete state paths. When protocol/frontend.md
changes, change this file (and the fixture).
"""

from __future__ import annotations

import asyncio
import json
import math
from pathlib import Path
from typing import Any

from . import ui_protocol as proto
from .hub import Hub

FIXTURE = Path(__file__).resolve().parents[3] / "protocol" / "fixtures" / "snapshot.json"
TICK = 0.1
SCENE_EVERY = 3.0  # seconds


def _pct(value: float) -> str:
    return f"{value * 100:.0f} %"


class Mock:
    def __init__(self, hub: Hub, fixture: Path = FIXTURE) -> None:
        self.hub = hub
        hub.backend = self
        self.model = proto.StateModel(json.loads(fixture.read_text()))
        self.model.set("hub", None)  # the hub owns this node
        self._replies: asyncio.Queue[proto.Message] = asyncio.Queue()
        self._names = self._scene_names()
        self._t = 0.0

    def _scene_names(self) -> list[str]:
        count = self.model.get("scenes.count", 0)
        names = [f"Scene {i + 1}" for i in range(count)]
        for entry in self.model.get("scenes.window", []):
            names[entry["index"]] = entry["name"]
        return names

    # --- backend interface -------------------------------------------------------

    def send(self, message: proto.Message) -> bool:
        self._replies.put_nowait(self._handle(message))
        return True

    async def run(self) -> None:
        self.hub.set_live(True)
        self.hub.on_snapshot(self.model.snapshot())
        scene_clock = 0.0
        while True:
            await asyncio.sleep(TICK)
            while not self._replies.empty():
                self.hub.on_response(self._replies.get_nowait())
            self._t += TICK
            scene_clock += TICK
            if scene_clock >= SCENE_EVERY:
                scene_clock = 0.0
                self._next_scene()
            self._sweep()
            if patch := self.model.flush():
                self.hub.on_patch(patch)

    # --- scripted behaviour --------------------------------------------------------

    def _scene_entry(self, i: int) -> dict[str, Any]:
        return {"index": i, "name": self._names[i], "color": 0x3366CC + i * 0x0A0A0A}

    def _next_scene(self) -> None:
        count = self.model.get("scenes.count")
        selected = (self.model.get("scenes.selected") + 1) % count
        self.model.set("scenes.selected", selected)
        self.model.set("scenes.fired", self._scene_entry(selected))
        window = [self._scene_entry(i) for i in range(max(0, selected - 3), min(count, selected + 4))]
        self.model.set("scenes.window", window)

    def _sweep(self) -> None:
        """Drive the Drive loop's favorite dial back and forth."""
        value = round((math.sin(self._t) + 1) / 2, 2)
        self.model.set("loops.1.favorite.value", value)
        self.model.set("loops.1.favorite.display", f"{value * 10:.1f}")

    # --- methods ---------------------------------------------------------------------

    def _loop_position(self, index: Any) -> int | None:
        for pos, loop in enumerate(self.model.get("loops", [])):
            if loop["index"] == index:
                return pos
        return None

    def _handle(self, message: proto.Message) -> proto.Message:
        id_, method, params = message["id"], message["method"], message.get("params", {})
        handler = getattr(self, "_m_" + method.replace(".", "_"), None)
        if handler is None:
            return proto.error_response(id_, "unknown_method", method)
        try:
            return proto.response(id_, handler(params))
        except KeyError as e:
            return proto.error_response(id_, "bad_params", f"missing {e}")
        except LookupError as e:
            return proto.error_response(id_, "not_found", str(e))
        except (TypeError, ValueError) as e:
            return proto.error_response(id_, "bad_params", str(e))

    def _m_page_set(self, p: dict[str, Any]) -> Any:
        page = int(p["page"])
        if not 0 <= page <= 2:
            raise ValueError("page out of range")
        self.model.set("page", page)
        self.model.set("mode", ("transport", "loops", "favorites")[page])
        self.model.set("edit", None)
        return {"page": page}

    def _m_loop_set(self, p: dict[str, Any]) -> Any:
        pos = self._loop_position(p["loop"])
        if pos is None:
            raise LookupError("loop")
        self.model.set(f"loops.{pos}.on", bool(p["on"]))
        return {"on": bool(p["on"])}

    def _m_chain_select(self, p: dict[str, Any]) -> Any:
        pos = self._loop_position(p["loop"])
        if pos is None or p["chain"] not in self.model.get(f"loops.{pos}.chains"):
            raise LookupError("loop or chain")
        self.model.set(f"loops.{pos}.chain", p["chain"])
        return {"chain": p["chain"]}

    def _m_param_set(self, p: dict[str, Any]) -> Any:
        pos = self._loop_position(p["loop"])
        if pos is None:
            raise LookupError("loop")
        value = min(1.0, max(0.0, float(p["value"])))
        display = _pct(value)
        parameter = p["parameter"]
        favorite = self.model.get(f"loops.{pos}.favorite")
        edit = self.model.get("edit")
        if edit and edit["loop"] == p["loop"] and 1 <= parameter <= 8:
            base = f"edit.macros.{parameter - 1}"
        elif favorite and favorite["parameter"] == parameter:
            base = f"loops.{pos}.favorite"
        else:
            raise LookupError("parameter")
        self.model.set(f"{base}.value", value)
        self.model.set(f"{base}.display", display)
        return {"value": value, "display": display}

    def _m_preset_list(self, p: dict[str, Any]) -> Any:
        return {"names": self.model.get("presets.names", [])}

    def _m_preset_get(self, p: dict[str, Any]) -> Any:
        if p["name"] not in self.model.get("presets.names", []):
            raise LookupError(p["name"])
        return {"name": p["name"], "devices": {}}

    def _m_preset_store(self, p: dict[str, Any]) -> Any:
        name = self._names[int(p["scene_index"])]
        names = self.model.get("presets.names", [])
        if name in names and self.model.get("presets.pending_overwrite") != name:
            self.model.set("presets.pending_overwrite", name)
            self.hub.on_event(proto.event("preset.overwrite_pending", {"name": name}))
        else:
            self.model.set("presets.names", sorted({*names, name}))
            self.model.set("presets.pending_overwrite", None)
            self.model.set("presets.last", name)
            self.hub.on_event(proto.event("preset.saved", {"name": name}))
        return {}

    def _m_preset_cancel(self, p: dict[str, Any]) -> Any:
        name = self.model.get("presets.pending_overwrite")
        self.model.set("presets.pending_overwrite", None)
        if name:
            self.hub.on_event(proto.event("preset.overwrite_cancelled", {"name": name}))
        return {"cancelled": bool(name)}

    def _m_preset_recall(self, p: dict[str, Any]) -> Any:
        found = p["name"] in self.model.get("presets.names", [])
        if found:
            self.model.set("presets.last", p["name"])
            self.hub.on_event(proto.event("preset.recalled", {"name": p["name"]}))
        return {"found": found}
