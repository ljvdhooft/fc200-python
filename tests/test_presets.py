import gzip
import json
import os
import tempfile
import unittest

import support  # noqa: F401
from fc200 import presets  # noqa: E402

TEMPLATE = """<?xml version="1.0" encoding="UTF-8"?>
<Ableton><LiveSet><Tracks><AudioTrack><DeviceChain><MainSequencer>
<ClipSlotList><ClipSlot><ClipSlot><Value><AudioClip>
<Name Value="template" /><Color Value="1" />
</AudioClip></Value></ClipSlot></ClipSlot></ClipSlotList>
</MainSequencer></DeviceChain></AudioTrack></Tracks></LiveSet></Ableton>
"""

PRESET: presets.Preset = {
    0: {"parameters": [0.0, 1.0, 77.6, 82.6, 1.0, 127.0, 126.0, 0.0], "chain": "POG"},
    6: {"parameters": [1.0, 55.0, 51.0, 41.0, 20.0, 127.0, 0.0, 0.0]},
}


class PresetFileTest(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.folder = self._tmp.name

    def tearDown(self):
        self._tmp.cleanup()

    def test_save_load_round_trip(self):
        presets.save(self.folder, "Song A", PRESET)
        self.assertTrue(presets.exists(self.folder, "Song A"))
        self.assertEqual(presets.load(self.folder, "Song A"), PRESET)

    def test_save_creates_json_folder(self):
        presets.save(self.folder, "x", PRESET)
        self.assertTrue(os.path.isfile(os.path.join(self.folder, "_json", "x.json")))

    def test_file_format_unchanged(self):
        # String keys, 2-space indent: same as files written before the refactor
        presets.save(self.folder, "x", PRESET)
        with open(presets.json_path(self.folder, "x")) as f:
            data = json.load(f)
        self.assertEqual(set(data), {"0", "6"})
        self.assertEqual(data["0"]["chain"], "POG")

    def test_load_missing(self):
        self.assertFalse(presets.exists(self.folder, "nope"))
        self.assertIsNone(presets.load(self.folder, "nope"))

    def test_load_invalid(self):
        os.makedirs(os.path.join(self.folder, "_json"))
        with open(presets.json_path(self.folder, "bad"), "w") as f:
            f.write('{"0": {"chain": "no parameters"}}')
        with self.assertRaises(ValueError):
            presets.load(self.folder, "bad")


class AlcTest(unittest.TestCase):
    def test_alc_from_template(self):
        xml = presets.alc_from_template(TEMPLATE, "Song A")
        self.assertIn('<Name Value="Song A">', xml)
        self.assertIn(f'<Color Value="{presets.CLIP_COLOR}">', xml)

    def test_write_alc(self):
        with tempfile.TemporaryDirectory() as folder:
            self.assertFalse(presets.write_alc(folder, "Song A"))
            with open(os.path.join(folder, "template.alc.xml"), "w") as f:
                f.write(TEMPLATE)
            self.assertTrue(presets.write_alc(folder, "Song A"))
            with gzip.open(presets.alc_path(folder, "Song A")) as f:
                self.assertIn(b'<Name Value="Song A">', f.read())


if __name__ == "__main__":
    unittest.main()
