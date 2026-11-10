from _Framework.ControlSurface import ControlSurface
from _Framework import Task
from . import config
from . import roland_exclusive as se
from .hardware import FC200Hardware, TaskHandle
from .MiraGUI import MiraGUI
from .OSCremote import OSCremote

from . import xmltodict

import gzip
import os
import json
import importlib
from collections.abc import Callable
from typing import Any

DEBUG = False


class FC200(ControlSurface):
    # Live objects (tracks, devices, parameters, chains, scenes) have no type stubs: Any
    _page: int
    # None when no pedalboard is found; handlers check that at runtime
    _track: Any
    _board: Any                             # chain 0 of the "FC200 Pedalboard" rack
    _led_status: dict[int, dict[se.Pedal, int]]   # page -> pedal -> LED value
    _fired_scene: Any | None
    _preset_store_confirm: bool | None
    _preset_store_blinking_led: TaskHandle | None
    _favorite_parameter: Any | None
    _favorite_parameter_pedal: se.Pedal | None
    _parameter_control: int | None          # board device index
    _parameter_control_selected: se.Pedal | None
    _parameter_control_selected_pedal: se.Pedal | None
    _parameter_control_selected_parameter: Any | None
    _parameter_control_chains: list[Any] | None
    _parameter_control_selected_chain: Any | None
    _parameter_control_selected_chain_index: int | None
    _parameter_control_blink: TaskHandle | None
    blink_leds_value: int
    _observed_params: list[tuple[Any, Callable[[], None]]]

    def __init__(self, c_instance: Any) -> None:
        super(FC200, self).__init__(c_instance)
        self.settings = config.Settings()
        self._hw = FC200Hardware(self._send_midi, self._tasks, self.log_message if DEBUG else None)
        self._setup_track()
        self._mira = MiraGUI(self, self._track_index, self._device_index)
        self._oscremote = OSCremote(self, self.settings.OSC_REMOTE_HOST, self.settings.OSC_REMOTE_PORT)

        if not self.song().is_ableton_link_enabled_has_listener(self._reload_config):
            self.song().add_is_ableton_link_enabled_listener(self._reload_config)

        self._setup()

        # Log to the Ableton Log.txt file
        self.log_message("--- FC200 Script Loaded ---")

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
                    self._device = device
                    self._device_index = j
                    self._board = device.chains[0]
                    self._page = 1
                    break

    def _setup(self) -> None:
        self._led_status = {}
        for p in range(self.settings.MIN_PAGE, self.settings.MAX_PAGE + 1):
            self._led_status[p] = {}
        self._hw.set_bank_display(' ', self._page)

        # Add listeners for page_0 (is_playing, metronome, current_scene)
        if not self.song().is_playing_has_listener(self._on_is_playing_changed):
            self.song().add_is_playing_listener(self._on_is_playing_changed)
            self._led_status[0][se.Pedal.P1] = 127 if self.song().is_playing else 0
            if DEBUG:
                self.log_message(f"Adding listener for is_playing")
        if not self.song().metronome_has_listener(self._on_metronome_changed):
            self.song().add_metronome_listener(self._on_metronome_changed)
            self._led_status[0][se.Pedal.P6] = 127 if self.song().metronome else 0
            if DEBUG:
                self.log_message(f"Adding listener for metronome state")
        if not self.song().view.selected_scene_has_listener(self._on_selected_scene_changed):
            self.song().view.add_selected_scene_listener(self._on_selected_scene_changed)
            if DEBUG:
                self.log_message(f"Adding listener for selected scene")

        self._fired_scene = None
        self._highlight_tuner_true = False
        self._preset_store_confirm = None
        self._preset_store_blinking_led = None
        self._favorite_parameter = None
        self._favorite_parameter_pedal = None
        self._parameter_control = None
        self._parameter_control_selected = None
        self._parameter_control_selected_pedal = None
        self._parameter_control_selected_parameter = None
        self._parameter_control_chains = None
        self._parameter_control_selected_chain = None
        self._parameter_control_selected_chain_index = None
        self._parameter_control_blink = None
        self._observed_params = []
        self._on_is_playing_changed()
        self._on_metronome_changed()
        self._on_selected_scene_changed()
        self._hw.leds_off()

        if self._track is not None and self._board is not None:
            self._volume_param = self._board.devices[self.settings.LOOP_VOLUME].parameters[1]
            self._tuner_rack = self._track.devices[self.settings.TUNER_RACK]
            self._tuner_device = self._tuner_rack.chains[self.settings.TUNER_CHAIN].devices[self.settings.TUNER_DEVICE]
            self._volume = self._volume_param.value
            if not self._volume_param.value_has_listener(self._highlight_tuner):
                self._volume_param.add_value_listener(self._highlight_tuner)
            if not self._track.playing_slot_index_has_listener(self._load_preset):
                self._track.add_playing_slot_index_listener(self._load_preset)
            if not self._tuner_device.parameters[1].value_has_listener(self._display_tuner):
                self._tuner_device.parameters[1].add_value_listener(self._display_tuner)

            self._listeners()
            self._init_leds()
            self.leds_recall()

    def _reload_config(self) -> None:
        importlib.reload(config)
        self.settings = config.Settings()
        self._remove_loop_listeners()
        self._setup()

        self.log_message("Reloading config!")
        for key, value in self.settings.__class__.__dict__.items():
            if not key.startswith('__'):
                self.log_message(f"{key}: {value}")

    def _display_tuner(self) -> None:
        if self._volume > 0:
            return
        if self._favorite_parameter is not None or self._parameter_control is not None:
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
        tolerance = 3
        if (tolerance * -1) < cents < tolerance:
            binary += 64
        if cents <= (tolerance * -1):
            binary += 1
        if cents >= tolerance:
            binary += 8
        self._hw.set_bank_display_temp(se.segments(note_a), binary)

    def _highlight_tuner(self) -> None:
        if self._volume_param.value > 0:
            if not self._highlight_tuner_true:
                return
            # Select self._board (Note C#-2)
            self._oscremote._send_osc(f"/remote/note/{self.settings.HIGHLIGHT_NOTES['board']}/1", 127)
            self._highlight_tuner_true = False
            return
        if self._highlight_tuner_true:
            return
        # Select Tuner (Note C-2)
        self._oscremote._send_osc(f"/remote/note/{self.settings.HIGHLIGHT_NOTES['tuner']}/1", 127)
        self._highlight_tuner_true = True

    def _store_preset(self) -> None:
        def check_preset_exists(preset_file_path):
            if os.path.exists(preset_file_path):
                return True
            return False

        def clip_slot_name(selected_scene_index):
            clip_slot = self._track.clip_slots[selected_scene_index]
            if not clip_slot.has_clip:
                return None
            return clip_slot.clip.name
        def copy_clip(selected_scene_index):
            source = self._track.clip_slots[0]
            if not source.has_clip:
                return None
            source.duplicate_clip_to(self._track.clip_slots[selected_scene_index])
            return True

        def get_parameter_values_for_preset():
            preset = {}
            for d in self.settings.LOOP_MAPPING:
                preset[d] = {"parameters": []}
                device = self._board.devices[d]
                for i in range(0, 8):
                    parameter = device.parameters[i]
                    preset[d]["parameters"].append(parameter.value)
                selected_chain = device.view.selected_chain
                preset[d]["chain"] = selected_chain.name
            return preset
        def store_dummy_clip(preset_folder, name):
            template_file = os.path.join(preset_folder, 'template.alc.xml')
            if not os.path.exists(template_file):
                return

            with open(template_file, 'r') as t:
                template = xmltodict.parse(t.read())
                if template:

                    template_clip = template['Ableton']['LiveSet']['Tracks']['AudioTrack']['DeviceChain']['MainSequencer']['ClipSlotList']['ClipSlot']['ClipSlot']['Value']['AudioClip']
                    template_clip['Name']['@Value'] = name
                    template_clip['Color']['@Value'] = 69

                    dummy_clip = xmltodict.unparse(template)
                    preset_file_name = "{}.alc".format(name)
                    path = os.path.join(preset_folder, preset_file_name)
                    with gzip.open(path, 'wb') as f:
                        f.write(dummy_clip.encode('utf-8'))

            return

        def store_preset(preset, preset_folder, name):
            preset_file_name = "{}.json".format(name)
            path = os.path.join(preset_folder, "_json", preset_file_name)
            try:
                with open(path, 'w') as f:
                    preset_dict = json.dumps(preset, indent=2)
                    f.write(preset_dict)
                    if DEBUG:
                        self.log_message("saved preset file " + path)
            except Exception as e:
                self.log_message("Error saving preset file: " + str(e))

            return

        all_scenes = list(self.song().scenes)
        selected_scene = self.song().view.selected_scene
        selected_scene_index = all_scenes.index(selected_scene)

        if clip_slot_name(selected_scene_index) is None:
            if copy_clip(selected_scene_index) is None:
                self.show_message('No clip on selected slot')
            return
        clip_name = clip_slot_name(selected_scene_index)

        preset_folder = self.settings.PRESET_FOLDER
        if not os.path.exists(preset_folder):
            return None

        preset_file_name = "{}.json".format(clip_name)
        preset_file_path = os.path.join(preset_folder, '_json/', preset_file_name)

        if check_preset_exists(preset_file_path) and self._preset_store_confirm is None:
            self._preset_store_confirm = False
            self._preset_store_blinking_led = self._hw.blink(se.Pedal.P8, 0.3)
            self.show_message(f"Overwrite reset {clip_name} ?")
            return
        else:
            self._preset_store_confirm = True

        if self._preset_store_confirm:
            preset = get_parameter_values_for_preset()
            store_preset(preset, preset_folder, clip_name)
            store_dummy_clip(preset_folder, clip_name)
            self._preset_store_confirm = None
            self.show_message("Saved preset: " + str(clip_name))
            if self._preset_store_blinking_led is not None:
                self._preset_store_blinking_led.kill()
                self._preset_store_blinking_led = None
            self._tasks.add(Task.sequence(Task.wait(0.3), Task.run(lambda: self._hw.flash(se.Pedal.P8)), Task.wait(0.1), Task.run(lambda: self._hw.flash(se.Pedal.P8)), Task.run(lambda: self._hw.flash(se.Pedal.P8)), Task.wait(0.1), Task.run(lambda: self._hw.flash(se.Pedal.P8))))

    def _load_preset(self) -> None:
        def load_preset(clip_name):
            preset_folder = self.settings.PRESET_FOLDER
            preset_file_name = "{}.json".format(clip_name)
            preset_file_path = os.path.join(preset_folder, '_json/', preset_file_name)

            if not os.path.exists(preset_file_path):
                return None

            try:
                with open(preset_file_path, 'r') as f:
                    data = f.read()
                    preset_dict = json.loads(data)
                    return preset_dict
            except Exception as e:
                self.log_message("Error reading preset file: " + str(e))

        def apply_preset(preset):
            for device in preset:
                d = preset[device]
                parameters = d['parameters']
                for p, v in enumerate(parameters):
                    parameter = self._board.devices[int(device)].parameters[int(p)]
                    if not parameter.is_enabled:
                        continue
                    parameter.value = v
                if "chain" in d:
                    chains = self._board.devices[int(device)].chains
                    for c in chains:
                        if c.name == d["chain"]:
                            self._board.devices[int(device)].view.selected_chain = c
                            break 
            return

        slot = self._track.playing_slot_index
        if slot < 0:
            return
        clip_name = self._track.clip_slots[slot].clip.name
        preset = load_preset(clip_name)
        if preset is None:
            return
        self._tasks.add(Task.run(lambda: apply_preset(preset)))

    def leds_recall(self) -> None:
        for i in self._led_status[self._page]:
            self._hw.led(i, self._led_status[self._page][i])

    def blink_leds(self) -> None:
        # Pedals 1-4 and 6-9, as in parameter_control
        for pedal in se.NUMBER_PEDALS:
            if pedal in (se.Pedal.P5, se.Pedal.P10):
                continue
            if pedal == self._parameter_control_selected:
                self._hw.led(pedal, 127)
                continue
            self._hw.led(pedal, self.blink_leds_value)
        self.blink_leds_value = 0 if self.blink_leds_value == 127 else 127

    def _expr_display(self, value: int, timeout: float = 1) -> None:
        v = str(int(value / 127 * 99)).zfill(2)
        self._hw.set_bank_display_temp(se.segments(v[0]), se.segments(v[1]), timeout)

    def _listeners(self) -> None:
        def update_led(pedal, loop):
            if DEBUG:
                self.log_message(f"parameter {loop} changed, updating LED {pedal}")
            value = self._observed_params[pedal][0]
            led_value = 127 if str(value) == "On" else 0
            self._led_status[1][pedal] = led_value 
            if self._page == 2 and self._parameter_control is None:
                self._mira.page_2()
            if self._parameter_control is not None:
                self._mira.parameter_control()

            if self._page != 1:
                return
            self._hw.led(pedal, led_value)
            return

        # Add listeners for page_1 (device on/off)
        for index, loop in enumerate(self.settings.LOOP_MAPPING):
            parameter = self._board.devices[loop].parameters[0]

            callback = lambda i=se.Pedal(index), l=loop: update_led(i, l)

            if not parameter.value_has_listener(callback):
                parameter.add_value_listener(callback)
                self._observed_params.append((parameter, callback))
        if DEBUG:
            self.log_message(f"Added listeners for {len(self._observed_params)} devices")
        return

    def _remove_loop_listeners(self) -> None:
        # Remove listeners for page_1 (device_on)
        for param, callback in self._observed_params:
            if param.value_has_listener(callback):
                param.remove_value_listener(callback)
        self._observed_params = []

    def _on_is_playing_changed(self) -> None:
        is_playing = self.song().is_playing 
        led_value = 127 if is_playing else 0
        self._led_status[0][se.Pedal.P1] = led_value
        if self._page != 0:
            return
        self._hw.led(se.Pedal.P1, led_value)
        return

    def _on_metronome_changed(self) -> None:
        self._metronome_state = self.song().metronome
        led_value = 127 if self._metronome_state else 0
        self._led_status[0][se.Pedal.P6] = led_value
        if self._page != 0:
            return
        self._hw.led(se.Pedal.P6, led_value)
        return

    def _on_selected_scene_changed(self) -> None:
        self._all_scenes = list(self.song().scenes)
        self._selected_scene = self.song().view.selected_scene
        self._selected_scene_index = self._all_scenes.index(self._selected_scene)
        if self._page < 2:
            self._mira.scene_overview()

    def _init_leds(self) -> None:
        for index, loop in enumerate(self.settings.LOOP_MAPPING):
            parameter = self._board.devices[loop].parameters[0]
            value = parameter.value
            led_value = 127 if value else 0
            self._led_status[1][se.Pedal(index)] = led_value
        return

    def handle_sysex(self, midi_bytes: tuple[int, ...]) -> None:
        body = se.parse(midi_bytes)
        if DEBUG:
            self.log_message(f"\nReceived SysEx: {midi_bytes}\nbody {body}")
        if body is None:
            return

        if self.settings.FORCE_SYSEX and self._hw.force_exclusive_mode(body):
            # Redraw LEDs and display for the current page
            self._page_move(0)
            if DEBUG:
                self.log_message("Set to sysex mode")
        if self._parameter_control is not None:
            self.parameter_control(body)
            return
        if self._page == 0:
            self.page_0(body)
            return
        if self._page == 1:
            self.page_1(body)
            return
        if self._page == 2:
            self.page_2(body)
            return

    def _page_move(self, direction: int) -> None:
        if not self.settings.MIN_PAGE <= self._page + direction <= self.settings.MAX_PAGE:
            return
        self._page += direction
        self._hw.leds_off()
        self.leds_recall()
        self._hw.set_bank_display(' ', self._page)
        self.show_message(f"Page {self._page}")
        if DEBUG:
            self.log_message(f"Page changed to {self._page}")

        if self._page < 2:
            self._mira.scene_overview()
            self._mira.highlight_parameter(-1)
            return
        if self._page == 2:
            self._mira.page_2()
            self._mira.highlight_parameter(-1)
            return

    def toggle_device(self, body: se.Body) -> None:
        pedal_loops = self._board.devices
        if body[1] >= len(self.settings.LOOP_MAPPING):
            return
        pedal_loop = pedal_loops[self.settings.LOOP_MAPPING[body[1]]]
        if pedal_loop.parameters[0].value == 0:
            pedal_loop.parameters[0].value = 1 
            return
        pedal_loop.parameters[0].value = 0 
        return

    def volume_control(self, value: int) -> None:
        if self._track is None or self._board is None:
            self._send_midi((0xB0, 0, value))
            return
        self._volume_param.value = value
        self._volume = value

    def freeze_control(self, value: int) -> None:
        if self._track is None or self._board is None:
            return
        parameters = self._board.devices[self.settings.LOOP_FREEZE].parameters
        def parameter_1():
            parameters[1].value = value
        def parameter_2():
            parameters[2].value = value
        self._tasks.add(Task.sequence(Task.run(lambda: parameter_1()), Task.wait(0.5), Task.run(lambda: parameter_2())))

    def favorite_parameter(self, body: se.Body) -> None:
        pedal = se.Pedal(body[1])
        parameter = self._board.devices[self.settings.LOOP_MAPPING[pedal]].parameters[self.settings.FAVORITE_PARAMETERS[pedal]]
        self._favorite_parameter_pedal = pedal
        self._favorite_parameter = parameter
        self._hw.leds_off()
        self._hw.led(pedal, 127)
        return

    def parameter_control(self, body: se.Body) -> None:
        # Map expression pedal to parameter_control selected parameter
        if se.changed(body, se.Pedal.EXP) and self._parameter_control_selected_parameter is not None:
            self._parameter_control_selected_parameter.value = body[2]
            self._expr_display(body[2], 0.5)
            return

        # Map CTL pedal to exit parameter_control mode
        if se.released(body, se.Pedal.CTL):
            return
        if se.pressed(body, se.Pedal.CTL) and self._parameter_control_blink is not None:
            self._parameter_control = None
            self._parameter_control_selected = None
            self._parameter_control_selected_pedal = None
            self._parameter_control_selected_parameter = None
            self._parameter_control_chains = None
            self._parameter_control_selected_chain = None
            self._parameter_control_selected_chain_index = None
            self._parameter_control_blink.kill()
            self._parameter_control_blink = None
            self._hw.leds_off()
            self._hw.flash(se.Pedal.CTL)
            self._hw.set_bank_display(' ', self._page)
            self._mira.page_2()
            self._mira.highlight_parameter(-1)
            return

        # Map bank up pedal to select different chains
        if se.pressed(body, se.Pedal.UP) and self._parameter_control_selected_chain_index is not None and self._parameter_control_chains is not None:
            if self._parameter_control_selected_chain_index <= 0:
                return
            self._board.devices[self._parameter_control].view.selected_chain = self._parameter_control_chains[self._parameter_control_selected_chain_index - 1]
            self._parameter_control_selected_chain_index -= 1
            self._hw.flash(se.Pedal.UP)
            return
        # Map bank down pedal to select different chains
        if se.pressed(body, se.Pedal.DOWN) and self._parameter_control_selected_chain_index is not None and self._parameter_control_chains is not None:
            if self._parameter_control_selected_chain_index >= len(self._parameter_control_chains) - 1:
                return
            self._board.devices[self._parameter_control].view.selected_chain = self._parameter_control_chains[self._parameter_control_selected_chain_index + 1]
            self._parameter_control_selected_chain_index += 1
            self._hw.flash(se.Pedal.DOWN)
            return

        # Initialize parameter_control mode with blinking
        if not self._parameter_control_selected and self._parameter_control_blink is None:
            self._favorite_parameter = None
            self._favorite_parameter_pedal = None
            self._parameter_control_chains = list(self._board.devices[self._parameter_control].chains)
            self._parameter_control_selected_chain = self._board.devices[self._parameter_control].view.selected_chain
            self._parameter_control_selected_chain_index = self._parameter_control_chains.index(self._board.devices[self._parameter_control].view.selected_chain)
            self.blink_leds_value = 127
            self.blink_leds()
            v = str(self._parameter_control).rjust(2)
            self._hw.set_bank_display(v[-2], v[-1])
            self._parameter_control_blink = self._tasks.add(Task.loop(Task.sequence(Task.wait(0.5), Task.run(self.blink_leds))))
            self._mira.parameter_control()
            self._mira.highlight_parameter(-1)
            return

        # Map pedals 1-4 and 6-9 to parameters (macros)
        if se.number_pedal_pressed(body) and body[1] not in (se.Pedal.P5, se.Pedal.P10):
            parameter_index = (body[1] - 4) if body[1] >= 5 else body[1] + 5
            self._parameter_control_selected = se.Pedal(body[1])
            self._parameter_control_selected_parameter = self._board.devices[self._parameter_control].parameters[parameter_index]

            self.show_message(f"{self._board.devices[self._parameter_control].name} - {self._parameter_control_selected_parameter.name}")
            self._hw.led(self._parameter_control_selected, 127)
            self._mira.highlight_parameter(body[1])

    def tap_tempo(self) -> None:
        self.song().tap_tempo()

    def start_button(self) -> None:
        self.song().start_playing()

    def stop_button(self) -> None:
        self.song().stop_playing()

    def stop_all(self) -> None:
        self.song().stop_all_clips()

    def start_scene(self) -> None:
        self._selected_scene.fire()
        self.move_scene(1)
        self._fired_scene = self._selected_scene
        self._mira.scene_overview()
        self.show_message(f"Fired: {self._selected_scene.name}")

    def move_scene(self, direction: int) -> None:
        new_index = self._selected_scene_index + direction 
        if 0 <= new_index < len(self._all_scenes):
            self.song().view.selected_scene = self._all_scenes[new_index]
            new_name = self._all_scenes[new_index].name
            self.show_message(f"Scene: {new_name}")
        return

    def toggle_click(self) -> None:
        self.song().metronome = not self.song().metronome
        return

    def page_0(self, body: se.Body) -> None:
        # Page UP
        if se.pressed(body, se.Pedal.UP):
            self._page_move(1)
            self._hw.flash(se.Pedal.UP)
            if self._preset_store_blinking_led is not None:
                self._preset_store_blinking_led.kill()
                self._preset_store_blinking_led = None
                self._preset_store_confirm = None
            return
        # Page DOWN
        if se.pressed(body, se.Pedal.DOWN):
            self._page_move(-1)
            self._hw.flash(se.Pedal.DOWN)
            if self._preset_store_blinking_led is not None:
                self._preset_store_blinking_led.kill()
                self._preset_store_blinking_led = None
                self._preset_store_confirm = None

            return
        # Expression pedal calls volume_control
        if se.changed(body, se.Pedal.EXP):
            self.volume_control(body[2])
            self._expr_display(body[2])
            return
        # CTL button calls tap_tempo
        if se.pressed(body, se.Pedal.CTL):
            if self._preset_store_blinking_led is not None:
                self._preset_store_blinking_led.kill()
                self._preset_store_blinking_led = None
                self._preset_store_confirm = None
                self.show_message("Cancelled saving preset!")
                self._hw.led(se.Pedal.P8, se.OFF)
                return
            self.tap_tempo()
            self._hw.flash(se.Pedal.CTL)
            return
        # Ableton "start" button
        if se.pressed(body, se.Pedal.P1):
            self.start_button()
            return
        # Ableton "stop" button and stop all clips
        if se.pressed(body, se.Pedal.P2):
            self.stop_button()
            self.stop_all()
            self._hw.flash(se.Pedal.P2)
            return
        # Ableton start scene
        if se.pressed(body, se.Pedal.P3):
            self.start_scene()
            self._hw.flash(se.Pedal.P3)
            return
        # Ableton scene down
        if se.pressed(body, se.Pedal.P4):
            self.move_scene(1)
            self._hw.flash(se.Pedal.P4)
            return
        # Ableton scene up
        if se.pressed(body, se.Pedal.P5):
            self.move_scene(-1)
            self._hw.flash(se.Pedal.P5)
            return
        # Ableton click on/off
        if se.pressed(body, se.Pedal.P6):
            self.toggle_click()
            return
        # Start scene and stop immediately (recall preset)
        if se.pressed(body, se.Pedal.P7):
            if self._track is None or self._board is None:
                return
            if self._metronome_state:
                self.toggle_click()
                self.start_scene()
                self._tasks.add(
                    Task.sequence(
                        Task.wait(0.1),
                        Task.run(self.stop_button),
                        Task.run(self.stop_all),
                        Task.run(self.toggle_click)
                    )
                )
                return
            self.start_scene()
            self._tasks.add(
                Task.sequence(
                    Task.wait(0.1),
                    Task.run(self.stop_button),
                    Task.run(self.stop_all),
                )
            )
            self._hw.flash(se.Pedal.P7)
            return
        # Store preset
        if se.pressed(body, se.Pedal.P8):
            if self._track is None or self._board is None:
                return
            self._store_preset()
            self._hw.flash(se.Pedal.P8)
            return
        # ForScore prev page
        if se.pressed(body, se.Pedal.P9):
            self._tasks.add(
                Task.sequence(
                    Task.run(lambda: self._oscremote._send_osc(f"/remote/pc/{self.settings.FORSCORE_PREV_PAGE}/2", 127)),
                    Task.run(lambda: self._hw.flash(se.Pedal.P9))
                )
            )
            return
        # ForScore next page
        if se.pressed(body, se.Pedal.P10):
            self._tasks.add(
                Task.sequence(
                    Task.run(lambda: self._oscremote._send_osc(f"/remote/pc/{self.settings.FORSCORE_NEXT_PAGE}/2", 127)),
                    Task.run(lambda: self._hw.flash(se.Pedal.P10))
                )
            )
            return

    def page_1(self, body: se.Body) -> None:
        # Page UP
        if se.pressed(body, se.Pedal.UP):
            self._page_move(1)
            self._hw.flash(se.Pedal.UP)
            return
        # Page DOWN
        if se.pressed(body, se.Pedal.DOWN):
            self._page_move(-1)
            self._hw.flash(se.Pedal.DOWN)
            return
        # Expression pedal calls volume_control
        if se.changed(body, se.Pedal.EXP):
            self.volume_control(body[2])
            self._expr_display(body[2])
            return
        # Pedal on the FOOT SW/EXP 1 jack calls freeze_control
        if se.changed(body, se.Pedal.FOOT_SW_EXP_1):
            self.freeze_control(body[2])
            return
        # CTL button calls tap_tempo
        if se.pressed(body, se.Pedal.CTL):
            self.tap_tempo()
            self._hw.flash(se.Pedal.CTL)
            return
        # Toggle Device On/Off for pedals 1 thru 10
        if se.number_pedal_pressed(body):
            if self._track is None or self._board is None:
                return
            self.toggle_device(body)
            return

    def page_2(self, body: se.Body) -> None:
        # Page UP
        if se.pressed(body, se.Pedal.UP):
            self._favorite_parameter = None
            self._favorite_parameter_pedal = None
            self._page_move(1)
            self._hw.flash(se.Pedal.UP)
            return
        # Page DOWN
        if se.pressed(body, se.Pedal.DOWN):
            self._favorite_parameter = None
            self._favorite_parameter_pedal = None
            self._page_move(-1)
            self._hw.flash(se.Pedal.DOWN)
            return
        # Expression pedal calls volume_control
        if se.changed(body, se.Pedal.EXP) and self._favorite_parameter is None and self._parameter_control is None:
            self.volume_control(body[2])
            self._expr_display(body[2])
            return
        # Device full parameter mode
        if self._favorite_parameter and self._favorite_parameter_pedal is not None and se.pressed(body, self._favorite_parameter_pedal):
            if self._track is None or self._board is None:
                return
            self._parameter_control = self.settings.LOOP_MAPPING[body[1]]
            self.parameter_control(body)
            return
        # Exit favorite parameter control
        if se.pressed(body, se.Pedal.CTL) and self._favorite_parameter is not None:
            if self._track is None or self._board is None:
                return
            self._favorite_parameter = None
            self._favorite_parameter_pedal = None
            self._hw.leds_off()
            self._hw.flash(se.Pedal.CTL)
            self._mira.highlight_parameter(-1)
            return
        # Control favorite parameter when selected with pedal
        if self._favorite_parameter and se.changed(body, se.Pedal.EXP):
            if self._track is None or self._board is None:
                return
            self._favorite_parameter.value = body[2]
            self._expr_display(body[2])
            return
        # Device favorite parameter mode
        if se.number_pedal_pressed(body):
            if self._track is None or self._board is None:
                return
            self.favorite_parameter(body)
            self._mira.highlight_parameter(body[1])
            return

    def disconnect(self) -> None:
        """Clean up when the script is unloaded."""
        self.log_message("(FC200) Removing all listeners...")

        # Remove listeners for page_0 (is_playing, metronome)
        if self.song().is_playing_has_listener(self._on_is_playing_changed):
            self.song().remove_is_playing_listener(self._on_is_playing_changed)
        if self.song().metronome_has_listener(self._on_metronome_changed):
            self.song().remove_metronome_listener(self._on_metronome_changed)
        if self.song().view.selected_scene_has_listener(self._on_selected_scene_changed):
            self.song().view.remove_selected_scene_listener(self._on_selected_scene_changed)

        if self._track is not None and self._board is not None:
            if self._volume_param.value_has_listener(self._highlight_tuner):
                self._volume_param.remove_value_listener(self._highlight_tuner)
            if self._track.playing_slot_index_has_listener(self._load_preset):
                self._track.remove_playing_slot_index_listener(self._load_preset)
            if self._tuner_device.parameters[1].value_has_listener(self._display_tuner):
                self._tuner_device.parameters[1].remove_value_listener(self._display_tuner)

            self._remove_loop_listeners()

        self.log_message("--- FC200 Script Unloaded ---")
        super(FC200, self).disconnect()
