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

FIXTURE = Path(__file__).resolve().parents[3] / "protocol" / "fixtures" / "dump.json"
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
        # Preset names aren't in the state (only their count), so the mock keeps them
        self._presets = ["Song A", "Song B", "Song C"]
        self.model.set("presets.count", len(self._presets))
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
        self.hub.on_dump(self.model.dump())
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
            if changes := self.model.flush():
                self.hub.on_changes(changes)

    # --- scripted behaviour --------------------------------------------------------

    def _scene_entry(self, i: int) -> dict[str, Any]:
        return {"index": i, "name": self._names[i], "color": 0x3366CC + i * 0x0A0A0A}

    def _select_scene(self, selected: int) -> None:
        count = self.model.get("scenes.count")
        self.model.set("scenes.selected", selected)
        window = [self._scene_entry(i) for i in range(max(0, selected - 3), min(count, selected + 4))]
        self.model.set("scenes.window", window)

    def _fire_scene(self) -> int:
        """Like pedal 3 on page 0: fire the selected scene, select the next."""
        fired = self.model.get("scenes.selected")
        self.model.set("scenes.fired", self._scene_entry(fired))
        self.hub.on_event(proto.event("scene.fired", self._scene_entry(fired)))
        self._select_scene((fired + 1) % self.model.get("scenes.count"))
        return fired

    def _next_scene(self) -> None:
        self._fire_scene()

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
        except PermissionError as e:
            return proto.error_response(id_, "unavailable", str(e))
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
        self.model.set("favorite", None)
        return {"page": page}

    def _m_scene_select(self, p: dict[str, Any]) -> Any:
        index = int(p["index"])
        if not 0 <= index < self.model.get("scenes.count"):
            raise LookupError(f"scene {index}")
        self._select_scene(index)
        return {"index": index}

    def _m_scene_list(self, p: dict[str, Any]) -> Any:
        return {"scenes": [self._scene_entry(i) for i in range(len(self._names))]}

    def _m_scene_fire(self, p: dict[str, Any]) -> Any:
        return {"index": self._fire_scene()}

    def _m_scene_fire_and_stop(self, p: dict[str, Any]) -> Any:
        index = self._fire_scene()
        self.model.set("transport.playing", False)
        return {"index": index}

    def _m_transport_play(self, p: dict[str, Any]) -> Any:
        self.model.set("transport.playing", True)
        return {}

    def _m_metronome_set(self, p: dict[str, Any]) -> Any:
        self.model.set("transport.metronome", bool(p["on"]))
        return {"on": bool(p["on"])}

    def _m_transport_stop(self, p: dict[str, Any]) -> Any:
        self.model.set("transport.playing", False)
        return {}

    def _m_loop_set(self, p: dict[str, Any]) -> Any:
        pos = self._loop_position(p["loop"])
        if pos is None:
            raise LookupError("loop")
        self.model.set(f"loops.{pos}.on", bool(p["on"]))
        return {"on": bool(p["on"])}

    def _m_loop_chain_select(self, p: dict[str, Any]) -> Any:
        pos = self._loop_position(p["loop"])
        if pos is None or p["chain"] not in self.model.get(f"loops.{pos}.chains"):
            raise LookupError("loop or chain")
        self.model.set(f"loops.{pos}.chain", p["chain"])
        return {"chain": p["chain"]}

    def _m_loop_param_set(self, p: dict[str, Any]) -> Any:
        pos = self._loop_position(p["loop"])
        if pos is None:
            raise LookupError("loop")
        value = min(1.0, max(0.0, float(p["value"])))
        display = _pct(value)
        parameter = p["parameter"]
        if not 1 <= parameter <= 8:
            raise LookupError("parameter")
        # Macros only; the mock tracks values where the state shows them
        bases = [f"loops.{pos}.macros.{parameter - 1}"]
        edit = self.model.get("edit")
        if edit and edit["loop"] == p["loop"]:
            bases.append(f"edit.macros.{parameter - 1}")
        favorite = self.model.get(f"loops.{pos}.favorite")
        if favorite and favorite["parameter"] == parameter:
            bases.append(f"loops.{pos}.favorite")
        for base in bases:
            self.model.set(f"{base}.value", value)
            self.model.set(f"{base}.display", display)
        return {"value": value, "display": display}

    def _m_loop_param_displays(self, p: dict[str, Any]) -> Any:
        if self._loop_position(p["loop"]) is None or not 1 <= p["parameter"] <= 8:
            raise LookupError("loop or parameter")
        return {"displays": [_pct(i / 127) for i in range(128)]}

    def _m_loop_param_select(self, p: dict[str, Any]) -> Any:
        if self._loop_position(p["loop"]) is None:
            raise LookupError("loop")
        edit = self.model.get("edit")
        if not edit or edit["loop"] != p["loop"]:
            raise PermissionError(f"loop {p['loop']} is not being edited")
        parameter = int(p["parameter"])
        if not 1 <= parameter <= 8:
            raise LookupError("parameter")
        self.model.set("edit.selected", parameter - 1)
        return {"parameter": parameter}

    def _m_edit_open(self, p: dict[str, Any]) -> Any:
        pos = self._loop_position(p["loop"])
        if pos is None:
            raise LookupError("loop")
        self.model.set("page", 2)
        self.model.set("mode", "parameter_control")
        self.model.set("favorite", None)
        edit = self.model.get("edit")
        if not edit or edit["loop"] != p["loop"]:
            # Macros 1-4 sit on pedals 6-9, macros 5-8 on pedals 1-4
            macros = [
                {"parameter": n, "pedal": n + 5 if n <= 4 else n - 4, "name": f"Macro {n}", "value": 0.0, "display": _pct(0)}
                for n in range(1, 9)
            ]
            name = self.model.get(f"loops.{pos}.name")
            self.model.set("edit", {"loop": p["loop"], "name": name, "selected": None, "macros": macros})
        return {"loop": p["loop"]}

    def _m_edit_close(self, p: dict[str, Any]) -> Any:
        if self.model.get("mode") == "parameter_control":
            self.model.set("mode", "favorites")
            self.model.set("edit", None)
        return {}

    def _m_preset_list(self, p: dict[str, Any]) -> Any:
        return {"names": sorted(self._presets), "missing_json": []}

    def _m_preset_get(self, p: dict[str, Any]) -> Any:
        if p["name"] not in self._presets:
            raise LookupError(p["name"])
        return {"name": p["name"], "devices": {}}

    def _m_preset_store(self, p: dict[str, Any]) -> Any:
        name = self._names[int(p["scene_index"])]
        if name in self._presets and self.model.get("presets.pending_overwrite") != name:
            self.model.set("presets.pending_overwrite", name)
            self.hub.on_event(proto.event("preset.overwrite_pending", {"name": name}))
        else:
            self._presets = sorted({*self._presets, name})
            self.model.set("presets.count", len(self._presets))
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
        found = p["name"] in self._presets
        if found:
            self.model.set("presets.last", p["name"])
            self.hub.on_event(proto.event("preset.recalled", {"name": p["name"]}))
        return {"found": found}
