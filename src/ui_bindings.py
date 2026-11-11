"""Connects FC200 to the frontend: mirrors its state into the StateModel
(protocol/frontend.md §3) and implements the protocol's methods (§5).

Live state that changes on its own (tempo, transport, scenes, loop parameters
and chains) is followed with listeners. State the pedals change (page, mode,
selected favorite, edited loop, fired scene) is re-read by refresh(), which FC200
calls on every update_display tick and the methods call when they're done. The
model drops values that didn't change, so refreshing often costs nothing on the
wire.

Methods run the same code paths as the pedals. Like pages, this uses FC200's
internals through `self.s` and has no Live imports at runtime.
"""

from __future__ import annotations

import json
from collections.abc import Callable
from functools import partial
from typing import TYPE_CHECKING, Any

from . import pages
from . import presets
from . import roland_exclusive as se
from . import ui_protocol as proto
from .ui_gateway import Handler, MethodError

if TYPE_CHECKING:
    from Live.DeviceParameter import DeviceParameter
    from Live.RackDevice import RackDevice

    from .FC200 import FC200
    from .listeners import Listeners

VERSION = "0.9.0"
SCENE_WINDOW = 3        # scenes shown before and after the selected one
MACROS = range(1, 9)    # rack parameters 1-8; parameter 0 switches the loop on/off


def _parameter(p: DeviceParameter) -> dict[str, Any]:
    span = p.max - p.min
    return {"name": p.name,
            "value": (p.value - p.min) / span if span else 0.0,
            "display": p.str_for_value(p.value)}


def _macro_pedal(parameter: int) -> int:
    """The 1-based number pedal that selects a macro in ParameterControl:
    parameters 1-4 -> pedals 6-9, parameters 5-8 -> pedals 1-4."""
    return parameter + 5 if parameter <= 4 else parameter - 4


class UiBindings(presets.PresetEvents):
    def __init__(self, surface: FC200, model: proto.StateModel,
                 emit: Callable[[proto.Message], None]) -> None:
        self.s = surface
        self.model = model
        self._emit = emit
        self._last_preset: str | None = None

    # --- State ----------------------------------------------------------------

    def setup(self, listeners: Listeners) -> None:
        """Add the listeners and write the whole state. FC200 calls this from
        _setup, so a config reload starts from scratch."""
        song = self.s.song()
        listeners.add(song, "tempo", self._on_transport)
        listeners.add(song, "is_playing", self._on_transport)
        listeners.add(song, "metronome", self._on_transport)
        listeners.add(song, "scenes", self.refresh)
        listeners.add(song.view, "selected_scene", self.refresh)
        if self.s._has_pedalboard:
            for pos, index in enumerate(self.s.settings.LOOP_MAPPING):
                rack = self.s._loop(index)
                watched = {0, *MACROS, self.s.settings.FAVORITE_PARAMETERS[pos]}
                for i in sorted(watched):
                    listeners.add(rack.parameters[i], "value", partial(self._on_parameter, pos, i))
                listeners.add(rack.view, "selected_chain", partial(self._on_chain, pos))
                listeners.add(rack, "chains", partial(self._on_chain, pos))
            assert self.s._presets is not None
            self.s._presets.subscribe(self)

        self.model.set("version", VERSION)
        found = self.s._has_pedalboard
        self.model.set("pedalboard", {
            "found": found,
            "track": self.s._board_track().name if found else None,
            "track_index": self.s._track_index if found else None,
            "device": self.s._device.name if found else None,
            "device_index": self.s._device_index if found else None,
        })
        self._on_transport()
        self.model.set("loops", [self._loop_state(pos) for pos in range(self._loop_count)])
        self._write_presets()
        self.refresh()

    def refresh(self) -> None:
        """Re-read what the pedals change: page, mode, scenes and the edited loop."""
        s = self.s
        self.model.set("page", s._page)
        self.model.set("mode", self._mode_name())

        scenes = s._all_scenes
        selected = s._selected_scene_index
        first = max(0, selected - SCENE_WINDOW)
        window = [self._scene(i) for i in range(first, min(len(scenes), selected + SCENE_WINDOW + 1))]
        self.model.set("scenes", {
            "count": len(scenes),
            "selected": selected,
            "fired": self._scene(scenes.index(s._fired_scene)) if s._fired_scene in scenes else None,
            "window": window,
        })

        self.model.set("favorite", self._favorite_state())
        self.model.set("edit", self._edit_state())

    @property
    def _loop_count(self) -> int:
        return len(self.s.settings.LOOP_MAPPING) if self.s._has_pedalboard else 0

    def _mode_name(self) -> str:
        if isinstance(self.s._mode, pages.ParameterControl):
            return "parameter_control"
        return ["transport", "loops", "favorites"][self.s._page]

    def _scene(self, index: int) -> dict[str, Any]:
        scene = self.s._all_scenes[index]
        return {"index": index, "name": scene.name, "color": scene.color}

    def _rack(self, pos: int) -> RackDevice:
        return self.s._loop(self.s.settings.LOOP_MAPPING[pos])

    def _loop_state(self, pos: int) -> dict[str, Any]:
        rack = self._rack(pos)
        favorite = self.s.settings.FAVORITE_PARAMETERS[pos]
        return {
            "index": self.s.settings.LOOP_MAPPING[pos],
            "pedal": pos + 1,
            "name": rack.name,
            "on": rack.parameters[0].value != 0,
            "chain": rack.view.selected_chain.name,
            "chains": [c.name for c in rack.chains],
            "favorite": {"parameter": favorite, **_parameter(rack.parameters[favorite])},
        }

    def _favorite_state(self) -> dict[str, Any] | None:
        page = self.s._favorites_page
        if self.s._mode is not page or page.pedal is None:
            return None
        pos = int(page.pedal)
        index = self.s.settings.FAVORITE_PARAMETERS[pos]
        rack = self._rack(pos)
        return {
            "loop": self.s.settings.LOOP_MAPPING[pos],
            "pedal": pos + 1,
            "loop_name": rack.name,
            "parameter": index,
            **_parameter(rack.parameters[index]),
        }

    def _edit_state(self) -> dict[str, Any] | None:
        mode = self.s._mode
        if not isinstance(mode, pages.ParameterControl):
            return None
        selected = None
        if mode.selected is not None:
            # Same mapping as ParameterControl._select_macro, as a 0-based position
            pedal = mode.selected
            selected = (pedal - 4 if pedal >= se.Pedal.P6 else pedal + 5) - 1
        return {
            "loop": mode.device_index,
            "name": mode.rack.name,
            "selected": selected,
            "macros": [{"parameter": i, "pedal": _macro_pedal(i), **_parameter(mode.rack.parameters[i])}
                       for i in MACROS],
        }

    def _write_presets(self) -> None:
        manager = self.s._presets
        if manager is None:
            self.model.set("presets", None)
            return
        self.model.set("presets", {"count": len(manager.preset_names()),
                                   "pending_overwrite": manager.pending_overwrite,
                                   "last": self._last_preset})

    def _on_transport(self) -> None:
        song = self.s.song()
        self.model.set("tempo", song.tempo)
        self.model.set("transport", {"playing": song.is_playing, "metronome": song.metronome})

    def _on_parameter(self, pos: int, index: int) -> None:
        rack = self._rack(pos)
        p = rack.parameters[index]
        if index == 0:
            self.model.set(f"loops.{pos}.on", p.value != 0)
        if index == self.s.settings.FAVORITE_PARAMETERS[pos]:
            selected = self.model.get("favorite.pedal") == pos + 1
            for key, value in _parameter(p).items():
                self.model.set(f"loops.{pos}.favorite.{key}", value)
                if selected:
                    self.model.set(f"favorite.{key}", value)
        edit = self.model.get("edit")
        if edit is not None and edit["loop"] == self.s.settings.LOOP_MAPPING[pos] and index in MACROS:
            for key, value in _parameter(p).items():
                self.model.set(f"edit.macros.{index - 1}.{key}", value)

    def _on_chain(self, pos: int) -> None:
        rack = self._rack(pos)
        self.model.set(f"loops.{pos}.chain", rack.view.selected_chain.name)
        self.model.set(f"loops.{pos}.chains", [c.name for c in rack.chains])

    # --- PresetEvents -----------------------------------------------------------

    def overwrite_pending(self, name: str) -> None:
        self._preset_event("overwrite_pending", {"name": name})

    def overwrite_cancelled(self, name: str) -> None:
        self._preset_event("overwrite_cancelled", {"name": name})

    def saved(self, name: str) -> None:
        self._last_preset = name
        self._preset_event("saved", {"name": name})

    def save_failed(self, name: str) -> None:
        self._preset_event("save_failed", {"name": name})

    def recalled(self, name: str) -> None:
        self._last_preset = name
        self._preset_event("recalled", {"name": name})

    def template_clip_copied(self, scene_index: int) -> None:
        self._preset_event("template_clip_copied", {"scene_index": scene_index})

    def template_clip_missing(self) -> None:
        self._preset_event("template_clip_missing", {})

    def scene_fired(self, index: int) -> None:
        """TransportPage._fire_scene calls this on every fire, also of the same scene again."""
        self._emit(proto.event("scene.fired", self._scene(index)))

    def _preset_event(self, name: str, data: dict[str, Any]) -> None:
        self._write_presets()
        self._emit(proto.event(f"preset.{name}", data))

    # --- Methods ----------------------------------------------------------------

    def handlers(self) -> dict[str, Handler]:
        """The protocol's methods. Each refreshes the state after it ran."""
        methods: dict[str, Handler] = {
            "page.set": self._page_set,
            "scene.select": self._scene_select,
            "scene.fire": self._scene_fire,
            "scene.fire_and_stop": self._scene_fire_and_stop,
            "transport.play": self._play,
            "transport.stop": self._stop,
            "metronome.set": self._metronome_set,
            "scene.list": self._scene_list,
            "loop.set": self._loop_set,
            "loop.chain.select": self._chain_select,
            "loop.param.set": self._param_set,
            "loop.param.select": self._param_select,
            "edit.open": self._edit_open,
            "edit.close": self._edit_close,
            "preset.list": self._preset_list,
            "preset.get": self._preset_get,
            "preset.store": self._preset_store,
            "preset.cancel": self._preset_cancel,
            "preset.recall": self._preset_recall,
        }

        def refreshing(method: Handler, params: dict[str, Any]) -> Any:
            result = method(params)
            self.refresh()
            return result
        return {name: partial(refreshing, method) for name, method in methods.items()}

    def _page_set(self, params: dict[str, Any]) -> Any:
        page = _arg(params, "page", int)
        settings = self.s.settings
        if not settings.MIN_PAGE <= page <= settings.MAX_PAGE:
            raise MethodError("bad_params", f"page must be {settings.MIN_PAGE}..{settings.MAX_PAGE}")
        self.s._show_page(page)
        return {"page": page}

    def _scene_select(self, params: dict[str, Any]) -> Any:
        index = _arg(params, "index", int)
        scenes = self.s._all_scenes
        if not 0 <= index < len(scenes):
            raise MethodError("not_found", f"no scene {index}")
        self.s.song().view.selected_scene = scenes[index]
        return {"index": index}

    def _scene_list(self, params: dict[str, Any]) -> Any:
        return {"scenes": [self._scene(i) for i in range(len(self.s._all_scenes))]}

    def _scene_fire(self, params: dict[str, Any]) -> Any:
        index = self.s._selected_scene_index
        self.s._transport_page._fire_scene()
        return {"index": index}

    def _play(self, params: dict[str, Any]) -> Any:
        self.s._transport_page.play()
        return {}

    def _stop(self, params: dict[str, Any]) -> Any:
        self.s._transport_page.stop()
        return {}

    def _metronome_set(self, params: dict[str, Any]) -> Any:
        on = _arg(params, "on", bool)
        self.s._transport_page.set_metronome(on)
        return {"on": on}

    def _scene_fire_and_stop(self, params: dict[str, Any]) -> Any:
        if not self.s._has_pedalboard:
            raise MethodError("unavailable", "no pedalboard")
        index = self.s._selected_scene_index
        self.s._transport_page.fire_and_stop()
        return {"index": index}

    def _loop_set(self, params: dict[str, Any]) -> Any:
        rack = self._loop_param(params)
        on = _arg(params, "on", bool)
        rack.parameters[0].value = 1 if on else 0
        return {"on": on}

    def _chain_select(self, params: dict[str, Any]) -> Any:
        rack = self._loop_param(params)
        name = _arg(params, "chain", str)
        chains = list(rack.chains)
        index = next((i for i, c in enumerate(chains) if c.name == name), None)
        if index is None:
            raise MethodError("not_found", f"no chain {name!r}")
        rack.view.selected_chain = chains[index]
        mode = self.s._mode
        if isinstance(mode, pages.ParameterControl) and mode.rack is rack:
            # Bank up/down step on from the chain chosen here
            mode._chain_index = index
        return {"chain": name}

    def _param_set(self, params: dict[str, Any]) -> Any:
        rack = self._loop_param(params)
        index = _arg(params, "parameter", int)
        if index not in MACROS:
            raise MethodError("not_found", f"parameter {index} is not a macro")
        value = min(1.0, max(0.0, float(_arg(params, "value", (int, float)))))
        p = rack.parameters[index]
        p.value = p.min + value * (p.max - p.min)
        result = _parameter(p)
        return {"value": result["value"], "display": result["display"]}

    def _param_select(self, params: dict[str, Any]) -> Any:
        self._loop_param(params)
        mode = self.s._mode
        if not isinstance(mode, pages.ParameterControl) or mode.device_index != params["loop"]:
            raise MethodError("unavailable", f"loop {params['loop']} is not being edited")
        parameter = _arg(params, "parameter", int)
        if parameter not in MACROS:
            raise MethodError("not_found", f"parameter {parameter} is not a macro")
        mode._select_macro(se.Pedal(_macro_pedal(parameter) - 1))
        return {"parameter": parameter}

    def _edit_open(self, params: dict[str, Any]) -> Any:
        self._loop_param(params)
        loop = params["loop"]
        if self.s._page != 2:
            self.s._show_page(2)
        self.s._set_mode(pages.ParameterControl(self.s, loop))
        return {"loop": loop}

    def _edit_close(self, params: dict[str, Any]) -> Any:
        # Like CTL in ParameterControl: back to the favorites page
        if isinstance(self.s._mode, pages.ParameterControl):
            self.s._show_page(self.s._page, announce=False)
        return {}

    def _preset_list(self, params: dict[str, Any]) -> Any:
        manager = self._presets()
        return {"names": manager.preset_names(), "missing_json": manager.missing_json()}

    def _preset_get(self, params: dict[str, Any]) -> Any:
        name = _arg(params, "name", str)
        preset = self._presets().get(name)
        if preset is None:
            raise MethodError("not_found", f"no preset {name!r}")
        return json.loads(preset.to_json())

    def _preset_store(self, params: dict[str, Any]) -> Any:
        scene_index = _arg(params, "scene_index", int)
        if not 0 <= scene_index < len(self.s._all_scenes):
            raise MethodError("bad_params", "scene_index out of range")
        self._presets().store(scene_index)
        return {}

    def _preset_cancel(self, params: dict[str, Any]) -> Any:
        return {"cancelled": self._presets().cancel()}

    def _preset_recall(self, params: dict[str, Any]) -> Any:
        return {"found": self._presets().recall(_arg(params, "name", str))}

    def _presets(self) -> presets.PresetManager:
        if self.s._presets is None:
            raise MethodError("unavailable", "no FC200 Pedalboard found")
        return self.s._presets

    def _loop_param(self, params: dict[str, Any]) -> RackDevice:
        """The rack for params["loop"], a board device index from LOOP_MAPPING."""
        if not self.s._has_pedalboard:
            raise MethodError("unavailable", "no FC200 Pedalboard found")
        index = _arg(params, "loop", int)
        if index not in self.s.settings.LOOP_MAPPING:
            raise MethodError("not_found", f"no loop {index}")
        return self.s._loop(index)


def _arg(params: dict[str, Any], key: str, kind: type | tuple[type, ...]) -> Any:
    """params[key], checked against kind. bool is not accepted as an int."""
    value = params.get(key)
    kinds = kind if isinstance(kind, tuple) else (kind,)
    if value is None or not isinstance(value, kinds) or (isinstance(value, bool) and bool not in kinds):
        raise MethodError("bad_params", f"{key!r} must be {' or '.join(k.__name__ for k in kinds)}")
    return value
