from __future__ import annotations

from _Framework.ControlSurface import ControlSurface
from _Framework import Task
from . import config
from . import pages
from . import presets
from . import roland_exclusive as se
from .hardware import FC200Hardware
from .listeners import Listeners
from .preset_feedback import PresetFeedback
from .MiraGUI import MiraGUI
from .OSCremote import OSCremote

import importlib
from collections.abc import Callable
from functools import partial
from typing import TYPE_CHECKING, cast

if TYPE_CHECKING:
    # Type-only: resolved from stubs/, never imported at runtime
    from Live.Chain import Chain
    from Live.DeviceParameter import DeviceParameter
    from Live.RackDevice import RackDevice
    from Live.Scene import Scene
    from Live.Track import Track

DEBUG = False


class FC200(ControlSurface):
    _page: int                              # index into _pages
    # None when no pedalboard is found; handlers check that at runtime
    _track: Track | None
    _board: Chain | None                    # chain 0 of the "FC200 Pedalboard" rack
    _fired_scene: Scene | None
    _presets: presets.PresetManager | None  # None without a pedalboard
    _pages: list[pages.Page]
    _mode: pages.Mode                       # receives the pedal events

    def __init__(self, c_instance: object) -> None:
        super(FC200, self).__init__(c_instance)
        self.settings = config.Settings()
        self._hw = FC200Hardware(self._send_midi, self._tasks, self.log_message if DEBUG else None)
        self._setup_track()
        self._mira = MiraGUI(self, self._track_index, self._device_index)
        self._oscremote = OSCremote(self.settings.OSC_REMOTE_HOST, self.settings.OSC_REMOTE_PORT)

        # Live for the whole script: toggling Link reloads the config
        self._script_listeners = Listeners(self.log_message)
        self._script_listeners.add(self.song(), "is_ableton_link_enabled", self._reload_config)
        # Added by _setup; removed on config reload and unload
        self._listeners = Listeners(self.log_message)

        self._setup()

        # Log to the Ableton Log.txt file
        self.log_message("--- FC200 Script Loaded ---")

    # --- Pedalboard and scenes ------------------------------------------------

    @property
    def _has_pedalboard(self) -> bool:
        return self._track is not None and self._board is not None

    def _pedalboard(self) -> Chain:
        """The pedalboard chain; only call once a pedalboard was found."""
        assert self._board is not None, "no FC200 Pedalboard found"
        return self._board

    def _board_track(self) -> Track:
        """The track holding the pedalboard; only call once a pedalboard was found."""
        assert self._track is not None, "no FC200 Pedalboard found"
        return self._track

    def _loop(self, index: int) -> RackDevice:
        """A loop (device) on the pedalboard. Loops are racks."""
        return cast("RackDevice", self._pedalboard().devices[index])

    # Scenes are read from the song on access, so they stay current when scenes
    # are added or removed. MiraGUI reads these too.
    @property
    def _all_scenes(self) -> list[Scene]:
        return list(self.song().scenes)

    @property
    def _selected_scene(self) -> Scene:
        return self.song().view.selected_scene

    @property
    def _selected_scene_index(self) -> int:
        return self._all_scenes.index(self._selected_scene)

    @property
    def _parameter_control(self) -> int | None:
        """Board device index being edited in ParameterControl, if any. MiraGUI reads this."""
        if isinstance(self._mode, pages.ParameterControl):
            return self._mode.device_index
        return None

    # --- Setup ----------------------------------------------------------------

    def _setup_track(self) -> None:
        self._page = 0
        self._track = None
        self._board = None

        tracks = self.song().tracks
        for i, track in enumerate(tracks):
            devices = track.devices
            for j, device in enumerate(devices):
                if device.name == "FC200 Pedalboard":
                    self.log_message(f"Found pedalboard at track {i+1} device {j+1}")
                    self._track = track
                    self._track_index = i
                    self._device = cast("RackDevice", device)
                    self._device_index = j
                    self._board = self._device.chains[0]
                    self._page = 1
                    break

    def _setup(self) -> None:
        self._presets = None
        self._transport_page = pages.TransportPage(self)
        self._loops_page = pages.LoopsPage(self)
        self._favorites_page = pages.FavoritesPage(self)
        self._pages = [self._transport_page, self._loops_page, self._favorites_page]
        self._mode = self._pages[self._page]

        # Page 0: transport LEDs and the scene overview
        self._listeners.add(self.song(), "is_playing", self._on_is_playing_changed)
        self._listeners.add(self.song(), "metronome", self._on_metronome_changed)
        self._listeners.add(self.song().view, "selected_scene", self._on_selected_scene_changed)

        self._fired_scene = None
        self._highlight_tuner_true = False
        self._on_is_playing_changed()
        self._on_metronome_changed()
        self._on_selected_scene_changed()

        if self._has_pedalboard:
            track = self._board_track()
            self._volume_param = self._loop(self.settings.LOOP_VOLUME).parameters[1]
            self._tuner_rack = cast("RackDevice", track.devices[self.settings.TUNER_RACK])
            self._tuner_device = self._tuner_rack.chains[self.settings.TUNER_CHAIN].devices[self.settings.TUNER_DEVICE]
            self._volume = self._volume_param.value
            self._listeners.add(self._volume_param, "value", self._highlight_tuner)
            self._listeners.add(self._tuner_device.parameters[1], "value", self._display_tuner)
            self._presets = presets.PresetManager(
                presets.PresetStore(self.settings.PRESET_FOLDER, self.log_message),
                track, self._pedalboard(), self.settings.LOOP_MAPPING,
                lambda fn: self._tasks.add(Task.run(fn)), self._listeners)
            self._presets.subscribe(PresetFeedback(
                self._hw, se.Pedal.P8, self.show_message, lambda: self._page, store_page=0))

            self._add_loop_listeners()

        self._redraw()

    def _reload_config(self) -> None:
        importlib.reload(config)
        self.settings = config.Settings()
        self._mode.on_exit()
        self._listeners.remove_all()
        if self._presets is not None:
            self._presets.disconnect()
        self._setup()

        self.log_message("Reloading config!")
        for key, value in self.settings.__class__.__dict__.items():
            if not key.startswith('__'):
                self.log_message(f"{key}: {value}")

    # --- Pages ----------------------------------------------------------------

    def handle_sysex(self, midi_bytes: tuple[int, ...]) -> None:
        body = se.parse(midi_bytes)
        if DEBUG:
            self.log_message(f"\nReceived SysEx: {midi_bytes}\nbody {body}")
        if body is None:
            return

        if self.settings.FORCE_SYSEX and self._hw.force_exclusive_mode(body):
            self._redraw()
            if DEBUG:
                self.log_message("Set to sysex mode")
        self._mode.handle(body)

    def _move_page(self, direction: int) -> None:
        """Go to the next or previous page. At the first or last page, the page is
        re-entered, which still drops its state (favorite, pending preset)."""
        index = self._page + direction
        if not self.settings.MIN_PAGE <= index <= self.settings.MAX_PAGE:
            self._show_page(self._page, announce=False)
            return
        self._show_page(index)

    def _show_page(self, index: int, announce: bool = True) -> None:
        self._mode.on_exit()
        self._page = index
        self._redraw()
        if announce:
            self.show_message(f"Page {self._page}")
        if DEBUG:
            self.log_message(f"Page changed to {self._page}")
        self._mode = self._pages[index]
        self._mode.on_enter()

    def _set_mode(self, mode: pages.Mode) -> None:
        self._mode.on_exit()
        self._mode = mode
        mode.on_enter()

    def _redraw(self) -> None:
        """LEDs and bank display for the current page."""
        self._hw.leds_off()
        for pedal, value in self._pages[self._page].leds.items():
            self._hw.led(pedal, value)
        self._hw.set_bank_display(' ', self._page)

    def _after(self, seconds: float, fn: Callable[[], None]) -> None:
        self._tasks.add(Task.sequence(Task.wait(seconds), Task.run(fn)))

    def _every(self, seconds: float, fn: Callable[[], None]) -> Task.Task:
        """Run fn every `seconds` until the returned task is killed."""
        return self._tasks.add(Task.loop(Task.sequence(Task.wait(seconds), Task.run(fn))))

    # --- Listeners ------------------------------------------------------------

    def _add_loop_listeners(self) -> None:
        """Page 1: a loop's on/off parameter drives its pedal LED."""
        def update_led(pedal: se.Pedal, parameter: DeviceParameter) -> None:
            if DEBUG:
                self.log_message(f"{parameter.name} changed, updating LED {pedal}")
            self._loops_page.set_led(pedal, 127 if str(parameter) == "On" else 0)
            if isinstance(self._mode, pages.FavoritesPage):
                self._mira.page_2()
            elif isinstance(self._mode, pages.ParameterControl):
                self._mira.parameter_control()

        for index, loop in enumerate(self.settings.LOOP_MAPPING):
            pedal = se.Pedal(index)
            parameter = self._loop(loop).parameters[0]
            self._loops_page.leds[pedal] = 127 if parameter.value else 0
            self._listeners.add(parameter, "value", partial(update_led, pedal, parameter))

    def _on_is_playing_changed(self) -> None:
        self._transport_page.set_led(se.Pedal.P1, 127 if self.song().is_playing else 0)

    def _on_metronome_changed(self) -> None:
        self._transport_page.set_led(se.Pedal.P6, 127 if self.song().metronome else 0)

    def _on_selected_scene_changed(self) -> None:
        if self._page < 2:
            self._mira.scene_overview()

    # --- Volume and tuner -----------------------------------------------------

    def _volume_control(self, value: int) -> None:
        if not self._has_pedalboard:
            self._send_midi((0xB0, 0, value))
            return
        self._volume_param.value = value
        self._volume = value

    def _display_tuner(self) -> None:
        if self._volume > 0:
            return
        if not self._mode.shows_tuner:
            return
        note = int(self._tuner_device.parameters[2].value) % 12
        cents: float = int(self._tuner_device.parameters[1].value) - 50
        notes = ['c', 'c#', 'd', 'd#', 'e', 'f', 'f#', 'g', 'g#', 'a', 'a#', 'b']
        note_a = notes[note]
        sharp = False
        if len(note_a) == 2:
            note_a = note_a[0]
            sharp = True

        offset = (float(self._tuner_rack.parameters[1].value) - 64) / 1.
        cents += offset

        binary = 0 if sharp == False else 4
        tolerance = 2
        if (tolerance * -1) < cents < tolerance:
            binary += 64
        if cents <= (tolerance * -1):
            binary += 1
        if cents >= tolerance:
            binary += 8
        # Stays until the volume goes up again (see _highlight_tuner)
        self._hw.set_bank_display_segments(se.segments(note_a), binary)

    def _highlight_tuner(self) -> None:
        if self._volume_param.value > 0:
            if not self._highlight_tuner_true:
                return
            # Select self._board (Note C#-2)
            self._oscremote._send_osc(f"/remote/note/{self.settings.HIGHLIGHT_NOTES['board']}/1", 127)
            self._highlight_tuner_true = False
            # The tuner display no longer applies: show the page again
            if self._mode.shows_tuner:
                self._hw.set_bank_display(' ', self._page)
            return
        if self._highlight_tuner_true:
            return
        # Select Tuner (Note C-2)
        self._oscremote._send_osc(f"/remote/note/{self.settings.HIGHLIGHT_NOTES['tuner']}/1", 127)
        self._highlight_tuner_true = True

    def disconnect(self) -> None:
        """Clean up when the script is unloaded."""
        self.log_message(f"Removing {len(self._listeners) + len(self._script_listeners)} listeners...")
        self._mode.on_exit()
        if self._presets is not None:
            self._presets.disconnect()
        self._listeners.remove_all()
        self._script_listeners.remove_all()
        self.log_message("--- FC200 Script Unloaded ---")
        super(FC200, self).disconnect()
