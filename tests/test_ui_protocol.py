import json
import unittest

import support  # noqa: F401
from fc200 import ui_protocol as p  # noqa: E402


def sample():
    return {
        "page": 0,
        "tempo": 120.0,
        "loops": [
            {"name": "Drive", "on": True, "favorite": {"value": 0.4}},
            {"name": "Delay", "on": False, "favorite": {"value": 0.1}},
        ],
        "presets": {"last": "Song A"},
    }


class StateModelTest(unittest.TestCase):
    def setUp(self):
        self.model = p.StateModel(sample())

    def test_initial_state_is_not_dirty(self):
        self.assertIsNone(self.model.flush())

    def test_coalescing(self):
        for i in range(100):
            self.model.set("loops.1.favorite.value", i / 100)
        self.model.set("tempo", 90.0)
        patch = self.model.flush()
        self.assertEqual(patch, {"loops.1.favorite.value": 0.99, "tempo": 90.0})
        self.assertIsNone(self.model.flush())

    def test_unchanged_value_is_not_dirty(self):
        self.model.set("tempo", 120.0)
        self.model.set("loops.0.name", "Drive")
        self.model.set("loops.0", sample()["loops"][0])
        self.assertIsNone(self.model.flush())

    def test_bool_and_int_differ(self):
        self.model.set("page", False)
        self.assertEqual(self.model.flush(), {"page": False})

    def test_set_back_to_original_still_sends_final_value(self):
        self.model.set("tempo", 100.0)
        self.model.set("tempo", 120.0)
        self.assertEqual(self.model.flush(), {"tempo": 120.0})

    def test_list_append_sends_whole_list(self):
        self.model.set("loops.2", {"name": "Verb", "on": True})
        patch = self.model.flush()
        self.assertEqual(list(patch), ["loops"])
        self.assertEqual(len(patch["loops"]), 3)

    def test_list_replaced_with_other_length(self):
        self.model.set("loops", [{"name": "Only"}])
        self.assertEqual(self.model.flush(), {"loops": [{"name": "Only"}]})

    def test_ancestor_swallows_descendants(self):
        self.model.set("loops.0.name", "X")
        self.model.set("loops.2", {"name": "Verb"})
        patch = self.model.flush()
        self.assertEqual(list(patch), ["loops"])
        self.assertEqual(patch["loops"][0]["name"], "X")

    def test_null_deletes_key(self):
        self.model.set("presets.last", None)
        self.assertEqual(self.model.flush(), {"presets.last": None})
        self.assertEqual(self.model.snapshot()["presets"], {})
        self.model.set("presets.last", None)
        self.assertIsNone(self.model.flush())

    def test_creates_missing_dicts(self):
        self.model.set("edit.loop", 2)
        self.assertEqual(self.model.snapshot()["edit"], {"loop": 2})

    def test_index_past_end_raises(self):
        with self.assertRaises(IndexError):
            self.model.set("loops.5.name", "x")

    def test_snapshot_is_deep_copy(self):
        snap = self.model.snapshot()
        snap["loops"][0]["name"] = "changed"
        self.assertEqual(self.model.get("loops.0.name"), "Drive")

    def test_set_copies_value(self):
        value = {"a": [1]}
        self.model.set("x", value)
        value["a"].append(2)
        self.assertEqual(self.model.get("x"), {"a": [1]})


class ReplicationTest(unittest.TestCase):
    def test_snapshot_plus_patches_equals_model(self):
        model = p.StateModel(sample())
        remote = model.snapshot()
        steps = [
            lambda: model.set("loops.0.on", False),
            lambda: (model.set("loops.1.favorite.value", 0.9), model.set("tempo", 80.0)),
            lambda: model.set("loops.2", {"name": "Verb", "on": True}),
            lambda: model.set("presets.last", None),
            lambda: model.set("edit", {"loop": 1, "macros": [{"value": 0.5}]}),
            lambda: model.set("edit.macros", []),
            lambda: model.set("loops", [{"name": "Solo"}]),
        ]
        for step in steps:
            step()
            patch = model.flush()
            self.assertIsNotNone(patch)
            # Over the wire, as the hub would see it
            p.apply_patch(remote, json.loads(json.dumps(patch)))
            self.assertEqual(remote, model.snapshot())

    def test_apply_patch_does_not_alias(self):
        remote = {}
        patch = {"a": {"b": 1}}
        p.apply_patch(remote, patch)
        remote["a"]["b"] = 2
        self.assertEqual(patch, {"a": {"b": 1}})


class CodecTest(unittest.TestCase):
    def test_round_trip(self):
        for message in (
            p.request(1, "param.set", {"loop": 2, "value": 0.5}),
            p.response(1, {"ok": True}),
            p.error_response(1, "bad_params", "nope"),
            p.event("state.patch", {"tempo": 90.0}),
        ):
            line = p.encode(message)
            self.assertTrue(line.endswith(b"\n"))
            self.assertEqual(line.count(b"\n"), 1)
            self.assertEqual(p.decode(line), message)
            self.assertEqual(p.decode(line.decode()), message)

    def test_non_ascii_survives(self):
        message = p.event("x", {"name": "Café ♪"})
        self.assertEqual(p.decode(p.encode(message)), message)

    def test_malformed_lines(self):
        for bad in (b"", b"not json", b"[1, 2]", b"42", b'{"foo": 1}', b"\xff\xfe",
                    b'{"id": 1}', b'{"id": 1, "method": 5}',
                    b'{"id": 1, "method": "a", "params": []}', b'{"event": 3}'):
            with self.assertRaises(p.ProtocolError, msg=bad):
                p.decode(bad)

    def test_request_without_params_is_valid(self):
        self.assertEqual(p.decode(b'{"id": 1, "method": "a"}')["method"], "a")


if __name__ == "__main__":
    unittest.main()
