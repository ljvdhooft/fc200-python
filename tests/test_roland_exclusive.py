import os
import sys
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))

import roland_exclusive as se  # noqa: E402


class ChecksumTest(unittest.TestCase):
    def test_sum_plus_checksum_is_multiple_of_128(self):
        for body in ([0, 0, 0], [0, 10, 127], [2, 1, 126], [3, 1, 3]):
            self.assertEqual((sum(body) + se.checksum(body)) % 128, 0)

    def test_zero_body(self):
        self.assertEqual(se.checksum([0, 0, 0]), 0)


class BuildParseTest(unittest.TestCase):
    def test_build(self):
        self.assertEqual(se.build([1, 7, 127]), (240, 65, 0, 114, 18, 1, 7, 127, 121, 247))

    def test_round_trip(self):
        for body in ([0, 10, 127], [0, 13, 64], [3, 0, 2]):
            self.assertEqual(se.parse(se.build(body)), body)

    def test_bad_checksum(self):
        msg = list(se.build([0, 10, 127]))
        msg[8] = (msg[8] + 1) % 128
        self.assertIsNone(se.parse(msg))

    def test_wrong_header(self):
        msg = list(se.build([0, 10, 127]))
        msg[3] = 115
        self.assertIsNone(se.parse(msg))

    def test_wrong_length(self):
        self.assertIsNone(se.parse((240, 65, 0, 114, 18, 0, 247)))

    def test_missing_end(self):
        msg = list(se.build([0, 10, 127]))
        msg[-1] = 0
        self.assertIsNone(se.parse(msg))


class PedalTest(unittest.TestCase):
    def test_pressed(self):
        self.assertTrue(se.pressed([0, 10, 127], se.PEDAL_UP))
        self.assertFalse(se.pressed([0, 10, 0], se.PEDAL_UP))
        self.assertFalse(se.pressed([1, 10, 127], se.PEDAL_UP))

    def test_released(self):
        self.assertTrue(se.released([0, 12, 0], se.PEDAL_CTL))
        self.assertFalse(se.released([0, 12, 127], se.PEDAL_CTL))

    def test_number_pedal_pressed(self):
        self.assertTrue(se.number_pedal_pressed([0, se.PEDAL_1, 127]))
        self.assertTrue(se.number_pedal_pressed([0, se.PEDAL_10, 127]))
        self.assertFalse(se.number_pedal_pressed([0, se.PEDAL_UP, 127]))
        self.assertFalse(se.number_pedal_pressed([0, se.PEDAL_1, 0]))

    def test_moved(self):
        self.assertTrue(se.moved([0, 13, 0], se.EXP_PEDAL))
        self.assertTrue(se.moved([0, 13, 64], se.EXP_PEDAL))
        self.assertFalse(se.moved([3, 13, 64], se.EXP_PEDAL))


class SegmentsTest(unittest.TestCase):
    def test_digit_and_letter(self):
        self.assertEqual(se.segments(8), 127)
        self.assertEqual(se.segments('a'), 126)

    def test_space(self):
        self.assertEqual(se.segments(' '), 0)
        self.assertEqual(se.segments('space'), 0)

    def test_unsupported(self):
        self.assertEqual(se.segments('#'), 0)
        self.assertEqual(se.segments(''), 0)


if __name__ == "__main__":
    unittest.main()
