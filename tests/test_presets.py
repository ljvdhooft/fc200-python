import gzip
import json
import os
import tempfile
import unittest
from types import SimpleNamespace

import support  # noqa: F401
from fc200 import presets  # noqa: E402

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


class AlcTest(unittest.TestCase):
    def test_alc_from_template(self):
        xml = presets.alc_from_template(TEMPLATE, "Song A")
        self.assertIn('<Name Value="Song A">', xml)
        self.assertIn(f'<Color Value="{presets.CLIP_COLOR}">', xml)


if __name__ == "__main__":
    unittest.main()
