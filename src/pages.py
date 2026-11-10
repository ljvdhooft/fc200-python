"""What the FC-200 pedals do, per page.

FC200 routes every pedal event to the active Mode: one of the pages
(0 transport, 1 loops, 2 favorites), or ParameterControl, which takes over
page 2 while one loop is being edited. Each mode owns its state and cleans it
up in on_exit().

Pages are part of FC200 and use its internals through `self.s`. No Live
imports at runtime, so they can be unit-tested with a fake surface.
"""

from __future__ import annotations

from typing import TYPE_CHECKING

from . import roland_exclusive as se

if TYPE_CHECKING:
    from _Framework.Task import Task
    from Live.Chain import Chain
    from Live.DeviceParameter import DeviceParameter

    from .FC200 import FC200
    from .hardware import FC200Hardware


class Mode:
    """Receives the pedal events while it is active."""

    def __init__(self, surface: FC200) -> None:
        self.s = surface

    @property
    def hw(self) -> FC200Hardware:
        return self.s._hw

    @property
    def shows_tuner(self) -> bool:
        """Whether the tuner may take over the bank display."""
        return True

    def on_enter(self) -> None:
        pass

    def on_exit(self) -> None:
        pass

    def handle(self, body: se.Body) -> None:
        raise NotImplementedError

    def show_value(self, value: int, timeout: float = 1) -> None:
        """Show a 0-127 value as 00-99 on the bank display for a moment."""
        v = str(int(value / 127 * 99)).zfill(2)
        self.hw.set_bank_display_temp(se.segments(v[0]), se.segments(v[1]), timeout)


class Page(Mode):
    """Bank pedals change the page, the expression pedal sets the volume and
    CTL taps the tempo. Pages override the hooks they need."""

    def __init__(self, surface: FC200) -> None:
        super().__init__(surface)
        self.leds: dict[se.Pedal, int] = {}     # shown while the page is active

    def set_led(self, pedal: se.Pedal, value: int) -> None:
        self.leds[pedal] = value
        if self.s._mode is self:
            self.hw.led(pedal, value)

    def handle(self, body: se.Body) -> None:
        if se.pressed(body, se.Pedal.UP):
            self.s._move_page(1)
            self.hw.flash(se.Pedal.UP)
        elif se.pressed(body, se.Pedal.DOWN):
            self.s._move_page(-1)
            self.hw.flash(se.Pedal.DOWN)
        elif se.changed(body, se.Pedal.EXP):
            self.on_expression(body[2])
        elif se.pressed(body, se.Pedal.CTL):
            self.on_ctl()
        elif se.number_pedal_pressed(body):
            self.on_number_pedal(se.Pedal(body[1]))
        else:
            self.on_other(body)

    def on_expression(self, value: int) -> None:
        self.s._volume_control(value)
        self.show_value(value)

    def on_ctl(self) -> None:
        self.s.song().tap_tempo()
        self.hw.flash(se.Pedal.CTL)

    def on_number_pedal(self, pedal: se.Pedal) -> None:
        pass

    def on_other(self, body: se.Body) -> None:
        pass


class TransportPage(Page):
    """Page 0: transport, scenes, presets and ForScore page turns.
    LEDs: pedal 1 is lit while playing, pedal 6 while the metronome is on."""

    def on_enter(self) -> None:
        self.s._mira.scene_overview()
        self.s._mira.highlight_parameter(-1)

    def on_exit(self) -> None:
        if self.s._presets is not None:
            self.s._presets.cancel()

    def on_ctl(self) -> None:
        # CTL cancels a pending preset overwrite before it taps the tempo
        if self.s._presets is not None and self.s._presets.cancel():
            return
        super().on_ctl()

    def on_number_pedal(self, pedal: se.Pedal) -> None:
        song = self.s.song()
        if pedal == se.Pedal.P1:
            song.start_playing()
        elif pedal == se.Pedal.P2:
            song.stop_playing()
            song.stop_all_clips()
            self.hw.flash(pedal)
        elif pedal == se.Pedal.P3:
            self._fire_scene()
            self.hw.flash(pedal)
        elif pedal == se.Pedal.P4:
            self._move_scene(1)
            self.hw.flash(pedal)
        elif pedal == se.Pedal.P5:
            self._move_scene(-1)
            self.hw.flash(pedal)
        elif pedal == se.Pedal.P6:
            song.metronome = not song.metronome
        elif pedal == se.Pedal.P7:
            if self.s._has_pedalboard:
                self._recall_scene()
                self.hw.flash(pedal)
        elif pedal == se.Pedal.P8:
            if self.s._presets is not None:
                self.s._presets.store(self.s._selected_scene_index)
                self.hw.flash(pedal)
        elif pedal == se.Pedal.P9:
            self._forscore(self.s.settings.FORSCORE_PREV_PAGE, pedal)
        elif pedal == se.Pedal.P10:
            self._forscore(self.s.settings.FORSCORE_NEXT_PAGE, pedal)

    def _fire_scene(self) -> None:
        """Launch the selected scene and select the next one."""
        scene = self.s._selected_scene
        scene.fire()
        self._move_scene(1)
        self.s._fired_scene = scene
        self.s._mira.scene_overview()
        self.s.show_message(f"Fired: {scene.name}")

    def _move_scene(self, direction: int) -> None:
        scenes = self.s._all_scenes
        index = self.s._selected_scene_index + direction
        if 0 <= index < len(scenes):
            self.s.song().view.selected_scene = scenes[index]
            self.s.show_message(f"Scene: {scenes[index].name}")

    def _recall_scene(self) -> None:
        """Launch the selected scene and stop right away: its clips recall their
        presets without anything playing. The metronome stays silent meanwhile."""
        song = self.s.song()
        metronome = song.metronome
        song.metronome = False
        self._fire_scene()

        def stop() -> None:
            song.stop_playing()
            song.stop_all_clips()
            song.metronome = metronome
        self.s._after(0.1, stop)

    def _forscore(self, program: int, pedal: se.Pedal) -> None:
        def send() -> None:
            self.s._oscremote._send_osc(f"/remote/pc/{program}/2", 127)
            self.hw.flash(pedal)
        self.s._after(0, send)


class LoopsPage(Page):
    """Page 1: number pedals switch the loops on and off; a pedal on the
    FOOT SW/EXP 1 jack drives freeze. LEDs follow the loops' on/off state."""

    def on_enter(self) -> None:
        self.s._mira.scene_overview()
        self.s._mira.highlight_parameter(-1)

    def on_number_pedal(self, pedal: se.Pedal) -> None:
        loops = self.s.settings.LOOP_MAPPING
        if not self.s._has_pedalboard or pedal >= len(loops):
            return
        on_off = self.s._loop(loops[pedal]).parameters[0]
        on_off.value = 1 if on_off.value == 0 else 0

    def on_other(self, body: se.Body) -> None:
        if se.changed(body, se.Pedal.FOOT_SW_EXP_1):
            self._freeze(body[2])

    def _freeze(self, value: int) -> None:
        """Set freeze parameter 1 now and parameter 2 half a second later."""
        if not self.s._has_pedalboard:
            return
        parameters = self.s._loop(self.s.settings.LOOP_FREEZE).parameters
        parameters[1].value = value

        def second() -> None:
            parameters[2].value = value
        self.s._after(0.5, second)


class FavoritesPage(Page):
    """Page 2: a number pedal picks that loop's favorite parameter for the
    expression pedal. Pressing the same pedal again edits the whole loop
    (ParameterControl); CTL drops the favorite."""

    def __init__(self, surface: FC200) -> None:
        super().__init__(surface)
        self.parameter: DeviceParameter | None = None
        self.pedal: se.Pedal | None = None

    @property
    def shows_tuner(self) -> bool:
        return self.parameter is None

    def on_enter(self) -> None:
        self.s._mira.page_2()
        self.s._mira.highlight_parameter(-1)

    def on_exit(self) -> None:
        self.parameter = None
        self.pedal = None

    def on_expression(self, value: int) -> None:
        if self.parameter is None:
            super().on_expression(value)
            return
        self.parameter.value = value
        self.show_value(value)

    def on_ctl(self) -> None:
        if self.parameter is None:
            return
        self.on_exit()
        self.hw.leds_off()
        self.hw.flash(se.Pedal.CTL)
        self.s._mira.highlight_parameter(-1)

    def on_number_pedal(self, pedal: se.Pedal) -> None:
        settings = self.s.settings
        if not self.s._has_pedalboard or pedal >= len(settings.LOOP_MAPPING):
            return
        device_index = settings.LOOP_MAPPING[pedal]
        if self.parameter is not None and pedal == self.pedal:
            self.s._set_mode(ParameterControl(self.s, device_index))
            return
        self.parameter = self.s._loop(device_index).parameters[settings.FAVORITE_PARAMETERS[pedal]]
        self.pedal = pedal
        self.hw.leds_off()
        self.hw.led(pedal, 127)
        self.s._mira.highlight_parameter(pedal)


class ParameterControl(Mode):
    """Edits one loop, on top of page 2. Pedals 1-4 and 6-9 pick one of its
    macros for the expression pedal, bank up/down step through its chains, CTL
    returns to the favorites page. The macro pedals blink until one is picked."""

    MACRO_PEDALS = tuple(p for p in se.NUMBER_PEDALS if p not in (se.Pedal.P5, se.Pedal.P10))

    def __init__(self, surface: FC200, device_index: int) -> None:
        super().__init__(surface)
        self.device_index = device_index
        self.rack = surface._loop(device_index)
        self.selected: se.Pedal | None = None
        self.parameter: DeviceParameter | None = None
        self._chains: list[Chain] = []
        self._chain_index = 0
        self._blink: Task | None = None
        self._blink_on = True

    @property
    def shows_tuner(self) -> bool:
        return False

    def on_enter(self) -> None:
        self._chains = list(self.rack.chains)
        self._chain_index = self._chains.index(self.rack.view.selected_chain)
        self._blink_on = True
        self._blink_leds()
        v = str(self.device_index).rjust(2)
        self.hw.set_bank_display(v[-2], v[-1])
        self._blink = self.s._every(0.5, self._blink_leds)
        self.s._mira.parameter_control()
        self.s._mira.highlight_parameter(-1)

    def on_exit(self) -> None:
        if self._blink is not None:
            self._blink.kill()
            self._blink = None

    def handle(self, body: se.Body) -> None:
        if se.changed(body, se.Pedal.EXP):
            if self.parameter is not None:
                self.parameter.value = body[2]
                self.show_value(body[2], 0.5)
        elif se.pressed(body, se.Pedal.CTL):
            self.s._show_page(self.s._page, announce=False)
            self.hw.flash(se.Pedal.CTL)
        elif se.pressed(body, se.Pedal.UP):
            self._step_chain(-1, se.Pedal.UP)
        elif se.pressed(body, se.Pedal.DOWN):
            self._step_chain(1, se.Pedal.DOWN)
        elif se.number_pedal_pressed(body) and body[1] in self.MACRO_PEDALS:
            self._select_macro(se.Pedal(body[1]))

    def _step_chain(self, direction: int, pedal: se.Pedal) -> None:
        index = self._chain_index + direction
        if not 0 <= index < len(self._chains):
            return
        self.rack.view.selected_chain = self._chains[index]
        self._chain_index = index
        self.hw.flash(pedal)

    def _select_macro(self, pedal: se.Pedal) -> None:
        # Pedals 1-4 -> parameters 5-8, pedals 6-9 -> parameters 1-4
        parameter_index = pedal - 4 if pedal >= se.Pedal.P6 else pedal + 5
        self.selected = pedal
        self.parameter = self.rack.parameters[parameter_index]
        self.s.show_message(f"{self.rack.name} - {self.parameter.name}")
        self.hw.led(pedal, 127)
        self.s._mira.highlight_parameter(pedal)

    def _blink_leds(self) -> None:
        value = 127 if self._blink_on else 0
        for pedal in self.MACRO_PEDALS:
            self.hw.led(pedal, 127 if pedal == self.selected else value)
        self._blink_on = not self._blink_on
