import gzip
import json
import os
import tempfile
import unittest
from types import SimpleNamespace

import support  # noqa: F401
from fc200 import presets  # noqa: E402
from fc200.listeners import Listeners  # noqa: E402
from fc200.preset_feedback import PresetFeedback  # noqa: E402

TEMPLATE = """<?xml version="1.0" encoding="UTF-8"?>
<Ableton><LiveSet><Tracks><AudioTrack><DeviceChain><MainSequencer>
<ClipSlotList><ClipSlot><ClipSlot><Value><AudioClip>
<Name Value="template" /><Color Value="1" />
</AudioClip></Value></ClipSlot></ClipSlot></ClipSlotList>
</MainSequencer></DeviceChain></AudioTrack></Tracks></LiveSet></Ableton>
"""

PRESET = presets.Preset({
    0: {"parameters": [0.0, 1.0, 77.6, 82.6, 1.0, 127.0, 126.0, 0.0], "chain": "POG"},
    6: {"parameters": [1.0, 55.0, 51.0, 41.0, 20.0, 127.0, 0.0, 0.0]},
})


def fake_board(devices):
    return SimpleNamespace(devices=devices)


def fake_rack(values, chains=("A", "B"), selected=0, enabled=True):
    chain_objs = [SimpleNamespace(name=n) for n in chains]
    return SimpleNamespace(
        parameters=[SimpleNamespace(value=v, is_enabled=enabled) for v in values],
        chains=chain_objs,
        view=SimpleNamespace(selected_chain=chain_objs[selected]),
    )


class PresetTest(unittest.TestCase):
    def test_read(self):
        board = fake_board([fake_rack(range(10), selected=1), fake_rack([5.0] * 8)])
        preset = presets.Preset.read(board, [0, 1])
        self.assertEqual(preset.loops[0], {"parameters": list(range(8)), "chain": "B"})
        self.assertEqual(preset.loops[1]["chain"], "A")

    def test_apply(self):
        rack = fake_rack([0.0] * 8)
        presets.Preset({0: {"parameters": [9.0] * 8, "chain": "B"}}).apply(fake_board([rack]))
        self.assertEqual([p.value for p in rack.parameters], [9.0] * 8)
        self.assertEqual(rack.view.selected_chain.name, "B")

    def test_apply_skips_disabled_parameters(self):
        rack = fake_rack([0.0] * 8, enabled=False)
        presets.Preset({0: {"parameters": [9.0] * 8}}).apply(fake_board([rack]))
        self.assertEqual([p.value for p in rack.parameters], [0.0] * 8)

    def test_json_round_trip(self):
        self.assertEqual(presets.Preset.from_json(PRESET.to_json()), PRESET)

    def test_json_format_unchanged(self):
        # String keys, as in files written before the refactor
        data = json.loads(PRESET.to_json())
        self.assertEqual(set(data), {"0", "6"})
        self.assertEqual(data["0"]["chain"], "POG")

    def test_from_json_invalid(self):
        with self.assertRaises(ValueError):
            presets.Preset.from_json('{"0": {"chain": "no parameters"}}')


class PresetStoreTest(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.log = []
        self.store = presets.PresetStore(self._tmp.name, self.log.append)

    def tearDown(self):
        self._tmp.cleanup()

    def test_save_load(self):
        self.assertTrue(self.store.save("Song A", PRESET))
        self.assertTrue(self.store.exists("Song A"))
        self.assertEqual(self.store.load("Song A"), PRESET)
        self.assertEqual(self.log, [])

    def test_save_creates_json_folder(self):
        self.store.save("x", PRESET)
        self.assertTrue(os.path.isfile(os.path.join(self.store.folder, "_json", "x.json")))

    def test_save_failure_is_logged(self):
        # A file where the _json folder should be
        open(os.path.join(self.store.folder, "_json"), "w").close()
        self.assertFalse(self.store.save("x", PRESET))
        self.assertEqual(len(self.log), 1)

    def test_load_missing(self):
        self.assertFalse(self.store.exists("nope"))
        self.assertIsNone(self.store.load("nope"))
        self.assertEqual(self.log, [])

    def test_load_invalid_is_logged(self):
        os.makedirs(os.path.join(self.store.folder, "_json"))
        with open(self.store.json_path("bad"), "w") as f:
            f.write('{"0": {"chain": "no parameters"}}')
        self.assertIsNone(self.store.load("bad"))
        self.assertEqual(len(self.log), 1)

    def test_missing_folder_is_logged(self):
        log = []
        presets.PresetStore(os.path.join(self.store.folder, "missing"), log.append)
        self.assertEqual(len(log), 1)

    def test_save_writes_alc_when_template_exists(self):
        self.store.save("Song A", PRESET)
        self.assertFalse(os.path.exists(self.store.alc_path("Song A")))
        with open(os.path.join(self.store.folder, "template.alc.xml"), "w") as f:
            f.write(TEMPLATE)
        self.store.save("Song A", PRESET)
        with gzip.open(self.store.alc_path("Song A")) as f:
            self.assertIn(b'<Name Value="Song A">', f.read())


class FakeTrack:
    def __init__(self, clip_names):
        self.clip_slots = [self._slot(n) for n in clip_names]
        self.playing_slot_index = -1
        self.listeners = []

    @staticmethod
    def _slot(name):
        slot = SimpleNamespace(has_clip=name is not None, clip=SimpleNamespace(name=name))

        def duplicate_clip_to(target):
            target.has_clip = True
            target.clip = SimpleNamespace(name=slot.clip.name)
        slot.duplicate_clip_to = duplicate_clip_to
        return slot

    def add_playing_slot_index_listener(self, f):
        self.listeners.append(f)

    def remove_playing_slot_index_listener(self, f):
        self.listeners.remove(f)

    def playing_slot_index_has_listener(self, f):
        return f in self.listeners

    def play(self, index):
        self.playing_slot_index = index
        for f in list(self.listeners):
            f()


class FakeHardware:
    def __init__(self):
        self.calls = []

    def blink_loop(self, pedal, interval):
        self.calls.append("blink")
        return SimpleNamespace(kill=lambda: self.calls.append("kill"))

    def flash_repeatedly(self, pedal, times):
        self.calls.append("flash")

    def led(self, pedal, value):
        self.calls.append(("led", value))


class RecordingEvents(presets.PresetEvents):
    def __init__(self):
        self.events = []

    def overwrite_pending(self, name):
        self.events.append(("overwrite_pending", name))

    def overwrite_cancelled(self, name):
        self.events.append(("overwrite_cancelled", name))

    def saved(self, name):
        self.events.append(("saved", name))

    def save_failed(self, name):
        self.events.append(("save_failed", name))

    def recalled(self, name):
        self.events.append(("recalled", name))

    def template_clip_copied(self, scene_index):
        self.events.append(("template_clip_copied", scene_index))

    def template_clip_missing(self):
        self.events.append(("template_clip_missing",))


class PresetManagerTest(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.store = presets.PresetStore(self._tmp.name, lambda msg: None)
        self.track = FakeTrack(["template", "Song A", None, "Song B"])
        self.board = fake_board([fake_rack([1.0] * 8)])
        self.listeners = Listeners(lambda msg: None)
        self.manager = presets.PresetManager(
            self.store, self.track, self.board, [0], lambda fn: fn(), self.listeners)
        self.recorder = RecordingEvents()
        self.manager.subscribe(self.recorder)

    def tearDown(self):
        self._tmp.cleanup()

    def test_store_new_preset(self):
        self.manager.store(1)
        self.assertTrue(self.store.exists("Song A"))
        self.assertEqual(self.recorder.events, [("saved", "Song A")])

    def test_store_existing_asks_to_confirm(self):
        self.manager.store(1)
        self.board.devices[0].parameters[0].value = 2.0
        self.manager.store(1)       # asks
        self.assertEqual(self.manager.pending_overwrite, "Song A")
        self.assertEqual(self.store.load("Song A").loops[0]["parameters"][0], 1.0)
        self.manager.store(1)       # confirms
        self.assertIsNone(self.manager.pending_overwrite)
        self.assertEqual(self.store.load("Song A").loops[0]["parameters"][0], 2.0)
        self.assertEqual(self.recorder.events, [
            ("saved", "Song A"), ("overwrite_pending", "Song A"), ("saved", "Song A")])

    def test_confirm_only_for_the_same_preset(self):
        self.manager.store(1)
        self.manager.store(3)
        self.recorder.events.clear()
        self.manager.store(1)       # asks for Song A
        self.manager.store(3)       # other preset: asks again instead of saving
        self.assertEqual(self.recorder.events, [
            ("overwrite_pending", "Song A"),
            ("overwrite_cancelled", "Song A"),
            ("overwrite_pending", "Song B")])

    def test_cancel(self):
        self.manager.store(1)
        self.manager.store(1)       # asks
        self.assertTrue(self.manager.cancel())
        self.assertEqual(self.recorder.events[-1], ("overwrite_cancelled", "Song A"))
        self.assertFalse(self.manager.cancel())

    def test_save_failed(self):
        open(os.path.join(self.store.folder, "_json"), "w").close()
        self.manager.store(1)
        self.assertEqual(self.recorder.events, [("save_failed", "Song A")])

    def test_store_on_empty_slot_copies_template_clip(self):
        self.manager.store(2)
        self.assertEqual(self.track.clip_slots[2].clip.name, "template")
        self.assertFalse(self.store.exists("template"))
        self.assertEqual(self.recorder.events, [("template_clip_copied", 2)])

    def test_store_without_template_clip(self):
        self.track.clip_slots[0].has_clip = False
        self.manager.store(2)
        self.assertEqual(self.recorder.events, [("template_clip_missing",)])

    def test_recall_by_name(self):
        self.store.save("Song A", presets.Preset({0: {"parameters": [5.0] * 8, "chain": "B"}}))
        self.assertTrue(self.manager.recall("Song A"))
        self.assertEqual(self.board.devices[0].parameters[0].value, 5.0)
        self.assertEqual(self.recorder.events, [("recalled", "Song A")])
        self.assertFalse(self.manager.recall("nope"))

    def test_recall_on_play(self):
        self.store.save("Song A", presets.Preset({0: {"parameters": [5.0] * 8, "chain": "B"}}))
        self.track.play(1)
        rack = self.board.devices[0]
        self.assertEqual(rack.parameters[0].value, 5.0)
        self.assertEqual(rack.view.selected_chain.name, "B")

    def test_preset_names(self):
        self.manager.store(3)
        self.manager.store(1)
        self.assertEqual(self.manager.preset_names(), ["Song A", "Song B"])

    def test_recall_listener_goes_with_the_registry(self):
        self.assertEqual(len(self.track.listeners), 1)
        self.listeners.remove_all()
        self.assertEqual(self.track.listeners, [])

    def test_disconnect_cancels_pending_overwrite(self):
        self.manager.store(1)
        self.manager.store(1)       # asks
        self.manager.disconnect()
        self.assertIsNone(self.manager.pending_overwrite)


class PresetFeedbackTest(unittest.TestCase):
    def setUp(self):
        self.hw = FakeHardware()
        self.messages = []
        self.page = 0
        self.feedback = PresetFeedback(self.hw, 7, self.messages.append, lambda: self.page, store_page=0)

    def test_blink_until_saved(self):
        self.feedback.overwrite_pending("Song A")
        self.feedback.saved("Song A")
        self.assertEqual(self.hw.calls, ["blink", "kill", "flash"])

    def test_cancel_turns_led_off_on_store_page_only(self):
        self.feedback.overwrite_pending("Song A")
        self.feedback.overwrite_cancelled("Song A")
        self.assertEqual(self.hw.calls, ["blink", "kill", ("led", 0)])
        self.page = 1
        self.feedback.overwrite_pending("Song A")
        self.feedback.overwrite_cancelled("Song A")
        self.assertEqual(self.hw.calls[-1], "kill")


class AlcTest(unittest.TestCase):
    def test_alc_from_template(self):
        xml = presets.alc_from_template(TEMPLATE, "Song A")
        self.assertIn('<Name Value="Song A">', xml)
        self.assertIn(f'<Color Value="{presets.CLIP_COLOR}">', xml)


if __name__ == "__main__":
    unittest.main()
