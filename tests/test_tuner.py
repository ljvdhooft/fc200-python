import unittest
from types import SimpleNamespace

import support  # noqa: F401
from fc200.tuner import TunerGate  # noqa: E402


class TunerGateTest(unittest.TestCase):
    def setUp(self):
        self.timers = []    # [seconds, fn, killed]
        self.changes = []

        def after(seconds, fn):
            timer = SimpleNamespace(seconds=seconds, fn=fn, killed=False)
            timer.kill = lambda: setattr(timer, "killed", True)
            self.timers.append(timer)
            return timer

        self.gate = TunerGate(0.05, 1.0, after, self.changes.append)

    def fire_timers(self):
        for timer in [t for t in self.timers if not t.killed]:
            timer.killed = True
            timer.fn()

    def test_hidden_until_a_note_sounds(self):
        self.gate.update(volume=0, level=0.0)
        self.assertFalse(self.gate.active)
        self.gate.update(volume=0, level=0.21)
        self.assertTrue(self.gate.active)
        self.assertEqual(self.changes, [True])

    def test_never_while_the_volume_is_up(self):
        self.gate.update(volume=64, level=0.21)
        self.assertFalse(self.gate.active)
        self.assertEqual(self.changes, [])

    def test_held_after_the_note_stops(self):
        self.gate.update(volume=0, level=0.21)
        self.gate.update(volume=0, level=0.03)
        self.gate.update(volume=0, level=0.0)
        self.assertTrue(self.gate.active)
        self.assertEqual([t.seconds for t in self.timers], [1.0])   # one timer, not two
        self.fire_timers()
        self.assertFalse(self.gate.active)
        self.assertEqual(self.changes, [True, False])

    def test_a_new_note_cancels_the_hold(self):
        self.gate.update(volume=0, level=0.21)
        self.gate.update(volume=0, level=0.0)
        self.gate.update(volume=0, level=0.18)
        self.assertTrue(self.timers[0].killed)
        self.assertTrue(self.gate.active)
        self.assertEqual(self.changes, [True])

    def test_volume_up_hides_at_once(self):
        self.gate.update(volume=0, level=0.21)
        self.gate.update(volume=0, level=0.0)
        self.gate.update(volume=10, level=0.0)
        self.assertFalse(self.gate.active)
        self.assertTrue(self.timers[0].killed)
        self.assertEqual(self.changes, [True, False])


if __name__ == "__main__":
    unittest.main()
