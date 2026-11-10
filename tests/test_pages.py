import unittest
from types import SimpleNamespace

import support  # noqa: F401
from fc200 import pages  # noqa: E402
from fc200 import roland_exclusive as se  # noqa: E402

P = se.Pedal


def press(pedal):
    return [se.Area.PEDAL_STATUS, pedal, se.ON]


def release(pedal):
    return [se.Area.PEDAL_STATUS, pedal, se.OFF]


def move(pedal, value):
    return [se.Area.PEDAL_STATUS, pedal, value]


class Recorder:
    """Records every method call as (name, *args)."""

    def __init__(self):
        self.calls = []

    def __getattr__(self, name):
        return lambda *args: self.calls.append((name, *args))


def fake_rack(name="Loop", chains=("A", "B", "C"), selected=1):
    chain_objs = [SimpleNamespace(name=n) for n in chains]
    return SimpleNamespace(
        name=name,
        parameters=[SimpleNamespace(name=f"p{i}", value=0.0) for i in range(10)],
        chains=chain_objs,
        view=SimpleNamespace(selected_chain=chain_objs[selected]),
    )


class FakeSurface:
    """The parts of FC200 that pages use, with the same page/mode switching."""

    def __init__(self):
        self._hw = Recorder()
        self._mira = Recorder()
        self._oscremote = Recorder()
        self._presets = None
        self._has_pedalboard = True
        self._racks = [fake_rack(f"Loop {i}") for i in range(11)]
        self.settings = SimpleNamespace(
            LOOP_MAPPING=[0, 1, 2, 3, 4, 6, 7, 8, 9], LOOP_FREEZE=10,
            FAVORITE_PARAMETERS=[6, 1, 1, 1, 1, 1, 2, 1, 2, 1],
            FORSCORE_PREV_PAGE=0, FORSCORE_NEXT_PAGE=1)
        self.song_obj = SimpleNamespace(
            metronome=True, view=SimpleNamespace(selected_scene=None), calls=[],
            tap_tempo=lambda: self.song_obj.calls.append("tap_tempo"),
            start_playing=lambda: self.song_obj.calls.append("start"),
            stop_playing=lambda: self.song_obj.calls.append("stop"),
            stop_all_clips=lambda: self.song_obj.calls.append("stop_all"))
        self.messages = []
        self.volume = []
        self.pending = []           # functions passed to _after
        self.every = []
        self._pages = [pages.TransportPage(self), pages.LoopsPage(self), pages.FavoritesPage(self)]
        self._page = 2
        self._mode = self._pages[2]

    def song(self):
        return self.song_obj

    def show_message(self, text):
        self.messages.append(text)

    def _loop(self, index):
        return self._racks[index]

    def _volume_control(self, value):
        self.volume.append(value)

    def _after(self, seconds, fn):
        self.pending.append(fn)

    def _every(self, seconds, fn):
        task = SimpleNamespace(killed=False)
        task.kill = lambda: setattr(task, "killed", True)
        self.every.append(task)
        return task

    def _set_mode(self, mode):
        self._mode.on_exit()
        self._mode = mode
        mode.on_enter()

    def _show_page(self, index, announce=True):
        self._mode.on_exit()
        self._page = index
        self._mode = self._pages[index]
        self._mode.on_enter()

    def _move_page(self, direction):
        self._show_page(max(0, min(2, self._page + direction)))


class PageTest(unittest.TestCase):
    def setUp(self):
        self.s = FakeSurface()

    def test_set_led_only_shows_on_the_active_page(self):
        self.s._pages[0].set_led(P.P1, 127)
        self.assertEqual(self.s._hw.calls, [])
        self.assertEqual(self.s._pages[0].leds, {P.P1: 127})
        self.s._pages[2].set_led(P.P1, 127)
        self.assertEqual(self.s._hw.calls, [("led", P.P1, 127)])

    def test_bank_pedals_move_pages(self):
        self.s._mode.handle(press(P.DOWN))
        self.assertEqual(self.s._page, 1)
        self.assertIn(("flash", P.DOWN), self.s._hw.calls)


class TransportPageTest(unittest.TestCase):
    def setUp(self):
        self.s = FakeSurface()
        self.s._show_page(0)
        self.page = self.s._mode

    def test_ctl_taps_tempo(self):
        self.page.handle(press(P.CTL))
        self.assertEqual(self.s.song_obj.calls, ["tap_tempo"])

    def test_ctl_cancels_pending_preset_first(self):
        self.s._presets = SimpleNamespace(cancel=lambda: True)
        self.page.handle(press(P.CTL))
        self.assertEqual(self.s.song_obj.calls, [])

    def test_ctl_release_does_nothing(self):
        self.page.handle(release(P.CTL))
        self.assertEqual(self.s.song_obj.calls, [])

    def test_leaving_cancels_pending_preset(self):
        cancelled = []
        self.s._presets = SimpleNamespace(cancel=lambda: cancelled.append(1) or True)
        self.page.handle(press(P.UP))
        self.assertEqual(cancelled, [1])

    def test_metronome_toggle(self):
        self.page.handle(press(P.P6))
        self.assertFalse(self.s.song_obj.metronome)

    def test_expression_sets_volume(self):
        self.page.handle(move(P.EXP, 64))
        self.assertEqual(self.s.volume, [64])

    def test_freeze(self):
        self.page.handle(move(P.FOOT_SW_EXP_1, 90))
        self.assertEqual(self.s._racks[10].parameters[1].value, 90)


class LoopsPageTest(unittest.TestCase):
    def setUp(self):
        self.s = FakeSurface()
        self.s._show_page(1)

    def test_number_pedal_toggles_loop(self):
        self.s._mode.handle(press(P.P6))     # LOOP_MAPPING[5] == 6
        self.assertEqual(self.s._racks[6].parameters[0].value, 1)
        self.s._mode.handle(press(P.P6))
        self.assertEqual(self.s._racks[6].parameters[0].value, 0)

    def test_pedal_10_is_not_mapped(self):
        self.s._mode.handle(press(P.P10))

    def test_freeze(self):
        self.s._mode.handle(move(P.FOOT_SW_EXP_1, 90))
        params = self.s._racks[10].parameters
        self.assertEqual((params[1].value, params[2].value), (90, 0.0))
        self.s.pending.pop()()
        self.assertEqual(params[2].value, 90)


class FavoritesPageTest(unittest.TestCase):
    def setUp(self):
        self.s = FakeSurface()
        self.page = self.s._pages[2]

    def test_pick_favorite_and_play_it(self):
        self.page.handle(press(P.P2))
        self.assertIs(self.page.parameter, self.s._racks[1].parameters[1])
        self.assertFalse(self.page.shows_tuner)
        self.page.handle(move(P.EXP, 100))
        self.assertEqual(self.page.parameter.value, 100)
        self.assertEqual(self.s.volume, [])

    def test_ctl_drops_favorite(self):
        self.page.handle(press(P.P2))
        self.page.handle(press(P.CTL))
        self.assertIsNone(self.page.parameter)
        self.assertEqual(self.s.song_obj.calls, [])     # no tap tempo on page 2

    def test_ctl_without_favorite_does_nothing(self):
        self.page.handle(press(P.CTL))
        self.assertEqual(self.s.song_obj.calls, [])

    def test_same_pedal_again_opens_parameter_control(self):
        self.page.handle(press(P.P2))
        self.page.handle(press(P.P2))
        self.assertIsInstance(self.s._mode, pages.ParameterControl)
        self.assertEqual(self.s._mode.device_index, 1)
        self.assertIsNone(self.page.parameter)

    def test_freeze_only_while_expression_controls_volume(self):
        self.page.handle(move(P.FOOT_SW_EXP_1, 90))
        self.assertEqual(self.s._racks[10].parameters[1].value, 90)
        self.page.handle(press(P.P2))
        self.page.handle(move(P.FOOT_SW_EXP_1, 20))
        self.assertEqual(self.s._racks[10].parameters[1].value, 90)

    def test_leaving_drops_favorite(self):
        self.page.handle(press(P.P2))
        self.page.handle(press(P.DOWN))
        self.assertIsNone(self.page.parameter)


class ParameterControlTest(unittest.TestCase):
    def setUp(self):
        self.s = FakeSurface()
        self.s._mode.handle(press(P.P2))
        self.s._mode.handle(press(P.P2))
        self.mode = self.s._mode
        self.rack = self.s._racks[1]

    def test_enter_blinks_macro_pedals(self):
        self.assertEqual(len(self.s.every), 1)
        lit = [c[1] for c in self.s._hw.calls if c[0] == "led" and c[2] == 127]
        self.assertEqual(set(lit), set(pages.ParameterControl.MACRO_PEDALS))

    def test_bank_display_shows_device_index_plus_one(self):
        self.assertIn(("set_bank_display", " ", "2"), self.s._hw.calls)

    def test_enter_turns_leds_off_before_blinking(self):
        # Pedals 5 and 10 aren't blinked, so their LEDs must be cleared on enter
        self.s._hw.calls.clear()
        self.s._set_mode(pages.ParameterControl(self.s, 4))
        self.assertEqual(self.s._hw.calls[0], ("leds_off",))

    def test_macro_mapping(self):
        self.mode.handle(press(P.P1))
        self.assertIs(self.mode.parameter, self.rack.parameters[5])
        self.mode.handle(press(P.P6))
        self.assertIs(self.mode.parameter, self.rack.parameters[1])
        self.mode.handle(move(P.EXP, 33))
        self.assertEqual(self.rack.parameters[1].value, 33)

    def test_pedal_5_and_10_are_not_macros(self):
        self.mode.handle(press(P.P5))
        self.mode.handle(press(P.P10))
        self.assertIsNone(self.mode.parameter)

    def test_chain_steps_stop_at_both_ends(self):
        self.mode.handle(press(P.DOWN))
        self.mode.handle(press(P.DOWN))     # already last: no IndexError (B3)
        self.assertEqual(self.rack.view.selected_chain.name, "C")
        for _ in range(3):
            self.mode.handle(press(P.UP))
        self.assertEqual(self.rack.view.selected_chain.name, "A")

    def test_ctl_returns_to_favorites_and_stops_blinking(self):
        self.mode.handle(press(P.CTL))
        self.assertIs(self.s._mode, self.s._pages[2])
        self.assertTrue(self.s.every[0].killed)


if __name__ == "__main__":
    unittest.main()
