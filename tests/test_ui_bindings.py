import unittest
from types import SimpleNamespace

import support  # noqa: F401
from fc200 import pages  # noqa: E402
from fc200 import roland_exclusive as se  # noqa: E402
from fc200 import ui_protocol as proto  # noqa: E402
from fc200.ui_bindings import UiBindings  # noqa: E402
from fc200.ui_gateway import MethodError  # noqa: E402
from test_pages import FakeSurface, press  # noqa: E402

P = se.Pedal


class Parameter:
    """A DeviceParameter with a 0..127 range, like the racks' macros."""

    def __init__(self, name, value=0.0, min=0.0, max=127.0):
        self.name, self.value, self.min, self.max = name, value, min, max

    def str_for_value(self, value):
        return f"{value:.0f}"


class FakeListeners:
    """Records listeners so a test can fire them: fire(subject, prop)."""

    def __init__(self):
        self.added = []

    def add(self, subject, prop, callback):
        self.added.append((subject, prop, callback))

    def fire(self, subject, prop):
        fired = [cb for s, p, cb in self.added if s is subject and p == prop]
        assert fired, f"no {prop} listener on {subject!r}"
        for callback in fired:
            callback()


class Surface(FakeSurface):
    """FakeSurface plus what the bindings read: scenes, tempo and parameter ranges."""

    def __init__(self):
        super().__init__()
        for rack in self._racks:
            rack.parameters = [Parameter(f"{rack.name} p{i}") for i in range(10)]
        self.fired = []
        self.scenes = [SimpleNamespace(name=f"Scene {i}", color=i) for i in range(10)]
        for scene in self.scenes:
            scene.fire = lambda scene=scene: self.fired.append(scene.name)
        self.song_obj.view.selected_scene = self.scenes[5]
        self.song_obj.scenes = self.scenes
        self.song_obj.tempo = 120.0
        self.song_obj.is_playing = False
        self._fired_scene = None
        self._transport_page = self._pages[0]
        self._favorites_page = self._pages[2]
        self._track = SimpleNamespace(name="Guitar")
        self._track_index = 31
        self._device = SimpleNamespace(name="FC200 Pedalboard")
        self._device_index = 4
        self.settings.MIN_PAGE, self.settings.MAX_PAGE = 0, 2

    def _board_track(self):
        return self._track

    @property
    def _selected_scene(self):
        return self.song_obj.view.selected_scene

    @property
    def _all_scenes(self):
        return list(self.scenes)

    @property
    def _selected_scene_index(self):
        return self.scenes.index(self.song_obj.view.selected_scene)


class FakePresets:
    def __init__(self):
        self.pending_overwrite = None
        self.subscribers = []
        self.stored = []

    def subscribe(self, listener):
        self.subscribers.append(listener)

    def preset_names(self):
        return ["A", "B"]

    def missing_json(self):
        return ["B"]

    def get(self, name):
        return SimpleNamespace(to_json=lambda: '{"0": {"parameters": [], "chain": "A"}}') \
            if name == "A" else None

    def store(self, scene_index):
        self.stored.append(scene_index)

    def cancel(self):
        return False

    def recall(self, name):
        return name == "A"


class UiBindingsTest(unittest.TestCase):
    def setUp(self):
        self.s = Surface()
        self.s._presets = FakePresets()
        self.model = proto.StateModel()
        self.events = []
        self.listeners = FakeListeners()
        self.ui = UiBindings(self.s, self.model, self.events.append)
        self.s._ui = self.ui
        self.ui.setup(self.listeners)
        self.model.flush()
        self.handlers = self.ui.handlers()

    def call(self, method, **params):
        return self.handlers[method](params)

    def error(self, method, **params):
        with self.assertRaises(MethodError) as cm:
            self.call(method, **params)
        return cm.exception.code

    # --- State ---

    def test_dump(self):
        state = self.model.dump()
        self.assertEqual(state["version"], "0.9.0")
        self.assertEqual((state["page"], state["mode"]), (2, "favorites"))
        self.assertEqual(state["tempo"], 120.0)
        self.assertEqual(state["transport"], {"playing": False, "metronome": True})
        self.assertEqual(state["scenes"]["selected"], 5)
        self.assertEqual([w["index"] for w in state["scenes"]["window"]], [2, 3, 4, 5, 6, 7, 8])
        self.assertEqual(len(state["loops"]), 9)
        self.assertEqual(state["loops"][5]["index"], 6)
        self.assertEqual(state["loops"][5]["pedal"], 6)
        self.assertEqual(state["loops"][0]["chain"], "B")
        self.assertEqual(state["loops"][0]["favorite"]["parameter"], 6)
        self.assertNotIn("edit", state)   # none = missing
        self.assertEqual(state["presets"], {"count": 2, "pending_overwrite": None,
                                            "last": None})
        self.assertEqual(self.s._presets.subscribers, [self.ui])

    def test_scene_window_is_clipped(self):
        self.s.song_obj.view.selected_scene = self.s.scenes[1]
        self.ui.refresh()
        window = self.model.get("scenes.window")
        self.assertEqual([w["index"] for w in window], [0, 1, 2, 3, 4])

    def test_tempo_listener(self):
        self.s.song_obj.tempo = 90.0
        self.listeners.fire(self.s.song_obj, "tempo")
        self.assertEqual(self.model.flush(), {"tempo": 90.0})

    def test_loop_on_listener(self):
        on_off = self.s._racks[2].parameters[0]
        on_off.value = 1
        self.listeners.fire(on_off, "value")
        self.assertEqual(self.model.flush(), {"loops.2.on": True})

    def test_favorite_listener_normalises(self):
        favorite = self.s._racks[0].parameters[6]
        favorite.value = 127
        self.listeners.fire(favorite, "value")
        self.assertEqual(self.model.flush(), {"loops.0.favorite.value": 1.0,
                                              "loops.0.favorite.display": "127"})

    def test_chain_listener(self):
        rack = self.s._racks[0]
        rack.view.selected_chain = rack.chains[2]
        self.listeners.fire(rack.view, "selected_chain")
        self.assertEqual(self.model.flush(), {"loops.0.chain": "C"})

    def test_selecting_a_favorite(self):
        self.s._mode.handle(press(P.P2))
        self.ui.refresh()
        self.assertEqual(self.model.flush(), {
            "favorite": {"loop": 1, "pedal": 2, "loop_name": "Loop 1", "parameter": 1,
                         "name": "Loop 1 p1", "value": 0.0, "display": "0"},
        })

        # The expression pedal moves it: the node and the loop list both follow
        parameter = self.s._racks[1].parameters[1]
        parameter.value = 127
        self.listeners.fire(parameter, "value")
        changes = self.model.flush()
        self.assertEqual(changes["favorite.value"], 1.0)
        self.assertEqual(changes["loops.1.favorite.value"], 1.0)

        # CTL drops it
        self.s._mode.handle(press(P.CTL))
        self.ui.refresh()
        self.assertEqual(self.model.flush(), {"favorite": None})

    def test_favorite_gives_way_to_parameter_control(self):
        self.s._mode.handle(press(P.P2))
        self.s._mode.handle(press(P.P2))
        self.ui.refresh()
        self.assertIsNone(self.model.get("favorite"))
        self.assertEqual(self.model.get("edit.loop"), 1)

    def test_parameter_control(self):
        self.s._mode.handle(press(P.P3))
        self.s._mode.handle(press(P.P3))
        self.s._mode.handle(press(P.P6))   # selects parameter 1
        self.ui.refresh()
        state = self.model.dump()
        self.assertEqual(state["mode"], "parameter_control")
        edit = state["edit"]
        self.assertEqual((edit["loop"], edit["selected"]), (2, 0))
        self.assertEqual([m["parameter"] for m in edit["macros"]], list(range(1, 9)))
        self.assertEqual([m["pedal"] for m in edit["macros"]], [6, 7, 8, 9, 1, 2, 3, 4])

        # A macro moving updates the edit node; the same parameter on another loop doesn't
        self.model.flush()
        macro = self.s._racks[2].parameters[3]
        macro.value = 63.5
        self.listeners.fire(macro, "value")
        other = self.s._racks[3].parameters[3]
        other.value = 10
        self.listeners.fire(other, "value")
        self.assertEqual(self.model.flush(), {"edit.macros.2.value": 0.5,
                                              "edit.macros.2.display": "64"})

    def test_preset_events_update_state_and_emit(self):
        self.ui.saved("Song A")
        self.assertEqual(self.model.get("presets.last"), "Song A")
        self.assertEqual(self.events, [{"event": "preset.saved", "data": {"name": "Song A"}}])

    def test_no_pedalboard(self):
        s = Surface()
        s._has_pedalboard = False
        model = proto.StateModel()
        UiBindings(s, model, lambda m: None).setup(FakeListeners())
        self.assertEqual(model.get("loops"), [])
        self.assertIsNone(model.get("presets"))
        with self.assertRaises(MethodError) as cm:
            UiBindings(s, model, lambda m: None).handlers()["loop.set"]({"loop": 0, "on": True})
        self.assertEqual(cm.exception.code, "unavailable")

    # --- Methods ---

    def test_page_set(self):
        self.assertEqual(self.call("page.set", page=0), {"page": 0})
        self.assertEqual(self.model.get("mode"), "transport")
        self.assertEqual(self.error("page.set", page=3), "bad_params")
        self.assertEqual(self.error("page.set", page="1"), "bad_params")

    def test_loop_set(self):
        self.call("loop.set", loop=6, on=True)
        self.assertEqual(self.s._racks[6].parameters[0].value, 1)
        self.assertEqual(self.error("loop.set", loop=5, on=True), "not_found")   # not in LOOP_MAPPING
        self.assertEqual(self.error("loop.set", loop=6, on=1), "bad_params")

    def test_chain_select_keeps_parameter_control_in_step(self):
        self.s._mode.handle(press(P.P1))
        self.s._mode.handle(press(P.P1))
        mode = self.s._mode
        self.assertIsInstance(mode, pages.ParameterControl)
        self.call("loop.chain.select", loop=0, chain="A")
        self.assertEqual(self.s._racks[0].view.selected_chain.name, "A")
        self.assertEqual(mode._chain_index, 0)
        self.assertEqual(self.error("loop.chain.select", loop=0, chain="Z"), "not_found")

    def test_param_set(self):
        result = self.call("loop.param.set", loop=0, parameter=2, value=0.5)
        self.assertEqual(result, {"value": 0.5, "display": "64"})
        self.assertEqual(self.s._racks[0].parameters[2].value, 63.5)
        self.call("loop.param.set", loop=0, parameter=2, value=7)
        self.assertEqual(self.s._racks[0].parameters[2].value, 127)     # clamped
        self.assertEqual(self.error("loop.param.set", loop=0, parameter=9, value=0.5), "not_found")
        self.assertEqual(self.error("loop.param.set", loop=0, parameter=0, value=0.5), "not_found")

    def test_presets(self):
        self.assertEqual(self.call("preset.list"), {"names": ["A", "B"], "missing_json": ["B"]})
        self.assertEqual(self.call("preset.get", name="A"), {"0": {"parameters": [], "chain": "A"}})
        self.assertEqual(self.error("preset.get", name="Z"), "not_found")
        self.assertEqual(self.call("preset.store", scene_index=3), {})
        self.assertEqual(self.s._presets.stored, [3])
        self.assertEqual(self.error("preset.store", scene_index=99), "bad_params")
        self.assertEqual(self.call("preset.recall", name="A"), {"found": True})
        self.assertEqual(self.call("preset.cancel"), {"cancelled": False})

    def test_pedalboard(self):
        self.assertEqual(self.model.get("pedalboard"), {
            "found": True, "track": "Guitar", "track_index": 31,
            "device": "FC200 Pedalboard", "device_index": 4})

    def test_scene_select(self):
        self.assertEqual(self.call("scene.select", index=8), {"index": 8})
        self.assertEqual(self.model.get("scenes.selected"), 8)
        self.assertEqual(self.s.fired, [])
        self.assertEqual(self.error("scene.select", index=10), "not_found")

    def test_scene_list(self):
        scenes = self.call("scene.list")["scenes"]
        self.assertEqual(len(scenes), self.model.get("scenes.count"))
        for entry in self.model.get("scenes.window"):
            self.assertEqual(scenes[entry["index"]], entry)

    def test_scene_fire_works_like_pedal_3_on_any_page(self):
        self.assertEqual(self.call("scene.fire"), {"index": 5})
        self.assertEqual(self.s.fired, ["Scene 5"])
        self.assertEqual(self.model.get("scenes.fired.index"), 5)
        self.assertEqual(self.model.get("scenes.selected"), 6)

    def test_transport_play_and_stop_work_like_pedals_1_and_2(self):
        self.assertEqual(self.call("transport.play"), {})
        self.assertEqual(self.call("transport.stop"), {})
        self.assertEqual(self.s.song_obj.calls, ["start", "stop", "stop_all"])

    def test_metronome_set_works_like_pedal_6(self):
        self.assertEqual(self.call("metronome.set", on=False), {"on": False})
        self.assertFalse(self.s.song_obj.metronome)

    def test_scene_fire_and_stop_works_like_pedal_7(self):
        self.assertEqual(self.call("scene.fire_and_stop"), {"index": 5})
        self.assertEqual(self.s.fired, ["Scene 5"])
        for stop in self.s.pending:
            stop()
        self.assertEqual(self.s.song_obj.calls, ["stop", "stop_all"])

    def test_every_fire_is_an_event_also_the_same_scene_again(self):
        self.ui.scene_fired(5)
        self.ui.scene_fired(5)
        fired = [e["data"] for e in self.events if e["event"] == "scene.fired"]
        self.assertEqual(fired, [{"index": 5, "name": "Scene 5", "color": 5}] * 2)

    def test_edit_open_select_close(self):
        self.s._show_page(0)
        self.assertEqual(self.call("edit.open", loop=2), {"loop": 2})
        self.assertEqual((self.model.get("page"), self.model.get("mode")), (2, "parameter_control"))
        self.assertEqual(self.model.get("edit.loop"), 2)

        self.assertEqual(self.call("loop.param.select", loop=2, parameter=5), {"parameter": 5})
        self.assertIs(self.s._mode.parameter, self.s._racks[2].parameters[5])
        self.assertEqual(self.model.get("edit.selected"), 4)
        self.assertEqual(self.error("loop.param.select", loop=2, parameter=0), "not_found")
        self.assertEqual(self.error("loop.param.select", loop=3, parameter=1), "unavailable")

        self.assertEqual(self.call("edit.close"), {})
        self.assertEqual(self.model.get("mode"), "favorites")
        self.assertIsNone(self.model.get("edit"))
        self.assertEqual(self.call("edit.close"), {})     # outside edit: nothing happens

    def test_edit_open_unknown_loop(self):
        self.assertEqual(self.error("edit.open", loop=5), "not_found")


if __name__ == "__main__":
    unittest.main()
