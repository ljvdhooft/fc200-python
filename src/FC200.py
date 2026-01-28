
import Live # type: ignore
from _Framework.ControlSurface import ControlSurface
from _Framework.InputControlElement import *
from _Framework.SliderElement import SliderElement
from _Framework.ButtonElement import ButtonElement
from _Framework.ButtonMatrixElement import ButtonMatrixElement
from _Framework.ChannelStripComponent import ChannelStripComponent
from _Framework.DeviceComponent import DeviceComponent
from _Framework.ControlSurfaceComponent import ControlSurfaceComponent
from _Framework.SessionZoomingComponent import SessionZoomingComponent
from _Framework.SessionComponent import SessionComponent
from _Framework import Task
from .SpecialMixerComponent import SpecialMixerComponent
from .SpecialTransportComponent import SpecialTransportComponent
from .SpecialSessionComponent import SpecialSessionComponent
from .SpecialZoomingComponent import SpecialZoomingComponent
from .SpecialViewControllerComponent import DetailViewControllerComponent
from .config import *
from .SegmentEncoder import SegmentEncoder
from .MiraGUI import MiraGUI
import os
import json



class FC200(ControlSurface):
    def __init__(self, c_instance):
        super(FC200, self).__init__(c_instance)
        self._mira = MiraGUI(self)

        self._page = 1
        self._track = self.song().tracks[TRACK]
        self._board = self._track.devices[MAIN_DEVICE].chains[0]

        self._led_status = {}
        for p in range(MIN_PAGE, MAX_PAGE + 1):
            self._led_status[p] = {}
        self.display(1, "")
        self.display(0, self._page)


        # Add listeners for page_0 (is_playing, metronome, current_scene)
        if not self.song().is_playing_has_listener(self._on_is_playing_changed):
            self.log_message(f"Adding listener for is_playing")
            self.song().add_is_playing_listener(self._on_is_playing_changed)
            self._led_status[0][0] = 127 if self.song().is_playing else 0
        if not self.song().metronome_has_listener(self._on_metronome_changed):
            self.log_message(f"Adding listener for metronome state")
            self.song().add_metronome_listener(self._on_metronome_changed)
            self._led_status[0][5] = 127 if self.song().metronome else 0
        if not self.song().view.selected_scene_has_listener(self._on_selected_scene_changed):
            self.log_message(f"Adding listener for selected scene")
            self.song().view.add_selected_scene_listener(self._on_selected_scene_changed)

        if not self._board.devices[LOOP_VOLUME].parameters[1].value_has_listener(self._highlight_tuner):
            self._board.devices[LOOP_VOLUME].parameters[1].add_value_listener(self._highlight_tuner)

        if not self._track.playing_slot_index_has_listener(self._load_preset):
            self._track.add_playing_slot_index_listener(self._load_preset)
        
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
        self._listeners()
        self._on_metronome_changed()
        self._on_selected_scene_changed()
        self.leds_off()
        self._init_leds()
        self.leds_recall()

        # Log to the Ableton Log.txt file
        self.log_message("--- FC200 Script Loaded ---")

    def _highlight_tuner(self):
        parameter = self._board.devices[LOOP_VOLUME].parameters[1]
        if parameter.value > 0:
            if not self._highlight_tuner_true:
                return
            # Select self._board (Note C#-2)
            self._send_midi((0x9F, HIGHLIGHT_NOTES['board'], 127))
            self._highlight_tuner_true = False
            return
        if self._highlight_tuner_true:
            return
        # Select Tuner (Note C-2)
        self._send_midi((0x9F, HIGHLIGHT_NOTES['tuner'], 127))
        self._highlight_tuner_true = True

    def _store_preset(self):
        if self._preset_store_confirm is not None and not self._preset_store_confirm:
            self.log_message("Overwrite!")
            self._preset_store_confirm = True

        def check_preset_exists(preset_file_path):
            if os.path.exists(preset_file_path):
                return True
            return False

        def clip_slot_name():
            all_scenes = list(self.song().scenes)
            selected_scene = self.song().view.selected_scene
            selected_scene_index = all_scenes.index(selected_scene)
            clip_slot = self._track.clip_slots[selected_scene_index]
            if not clip_slot.has_clip:
                return None
            return clip_slot.clip.name
        def get_parameter_values_for_preset():
            preset = {}
            for d in LOOP_MAPPING:
                preset[d] = {"parameters": []}
                device = self._board.devices[d]
                for i in range(0, 8):
                    parameter = device.parameters[i]
                    preset[d]["parameters"].append(parameter.value)
                selected_chain = device.view.selected_chain
                preset[d]["chain"] = selected_chain.name
            return preset
        def store_preset(preset, path, name):
            try:
                with open(path, 'w') as f:
                    preset_dict = json.dumps(preset, indent=2)
                    f.write(preset_dict)
                    self.log_message("saved preset file " + preset_file_path)
                    self.show_message("Saved preset: " + name)
            except Exception as e:
                self.log_message("Error reading preset file: " + str(e))

            return

        if clip_slot_name() is None:
            self.show_message('No clip on selected slot')
            return
        clip_name = clip_slot_name()

        preset_folder = os.path.dirname("/Users/ljvdhooft/Music/Ableton/User Library/eGit presets/")
        if not os.path.exists(preset_folder):
            return None

        preset_file_name = "{}.json".format(clip_name)
        preset_file_path = os.path.join(preset_folder, preset_file_name)

        if check_preset_exists(preset_file_path) and self._preset_store_confirm is None:
            self._preset_store_confirm = False
            self.blink_led_value = 127
            self._preset_store_blinking_led = self._tasks.add(Task.loop(Task.sequence(Task.wait(0.5), Task.run(lambda: self.blink_led(7)))))
            self.log_message("Confirm to overwrite")
            self.show_message(f"Overwrite reset {clip_name} ?")
            return
        else:
            self._preset_store_confirm = True

        preset = get_parameter_values_for_preset()
        store_preset(preset, preset_file_path, clip_name)
        if self._preset_store_blinking_led is not None:
            self.flash_led(7)
            self._preset_store_blinking_led.kill()
            self._preset_store_blinking_led = None

    def _load_preset(self):
        def load_preset(clip_name):
            preset_folder = os.path.dirname("/Users/ljvdhooft/Music/Ableton/User Library/eGit presets/")
            preset_file_name = "{}.json".format(clip_name)
            preset_file_path = os.path.join(preset_folder, preset_file_name)

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
        self.log_message(clip_name)
        preset = load_preset(clip_name)
        if preset is None:
            return
        self._tasks.add(Task.run(lambda: apply_preset(preset)))

    def _send_sysex(self, body):
        sysex_msg = (
                240, 
                65, 
                0,
                114,
                18,
                body[0],
                body[1],
                body[2],
                self._checksum(body),
                247
            )
        self.log_message(f"\nsending out: {sysex_msg}")
        self._send_midi(sysex_msg)
        return

    def _checksum(self, body):
        return (128 - ((body[0] + body[1] + body[2]) % 128)) % 128

    def display(self, number, character):
        binary = SegmentEncoder.get_segments(character)
        self._send_sysex([2, number, binary])

    def leds_off(self):
        for i in range(0, 9 + 1):
            self.led_status(i, 0)
        return

    def leds_recall(self):
        for i in self._led_status[self._page]:
            self.led_status(i, self._led_status[self._page][i])

    def led_status(self, pedal, value):
        bank = 1
        self._send_sysex([bank, pedal, value])
        return

    def flash_led(self, pedal_id):
        # Turn LED ON
        self.led_status(pedal_id, 127)
        
        # Schedule the OFF command 100ms later
        self._tasks.add(Task.sequence(
            Task.wait(0.1), # 0.1 seconds = 100ms
            Task.run(lambda: self.led_status(pedal_id, 0))
        ))

    def blink_led(self, led):
        self.led_status(led, self.blink_led_value)
        self.blink_led_value = 0 if self.blink_led_value == 127 else 127

    def blink_leds(self):
        for i in range(0, 9):
            if i == 4:
                continue
            if i == self._parameter_control_selected:
                self.led_status(self._parameter_control_selected, 127)
                continue
            self.led_status(i, self.blink_leds_value)
        self.blink_leds_value = 0 if self.blink_leds_value == 127 else 127

    def _listeners(self):
        def update_led(pedal, loop):
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
            self.led_status(pedal, led_value)
            return

        # Add listeners for page_1 (device on/off)
        for index, loop in enumerate(LOOP_MAPPING):
            parameter = self._board.devices[loop].parameters[0]

            callback = lambda i=index, l=loop: update_led(i, l)

            if not parameter.value_has_listener(callback):
                parameter.add_value_listener(callback)
                self._observed_params.append((parameter, callback))
        self.log_message(f"Added listeners for {len(self._observed_params)} devices")
        return

    def _on_is_playing_changed(self):
        is_playing = self.song().is_playing 
        led_value = 127 if is_playing else 0
        self._led_status[0][0] = led_value
        if self._page != 0:
            return
        self.led_status(0, led_value)
        return

    def _on_metronome_changed(self):
        self._metronome_state = self.song().metronome
        led_value = 127 if self._metronome_state else 0
        self._led_status[0][5] = led_value
        if self._page != 0:
            return
        self.led_status(5, led_value)
        return

    def _on_selected_scene_changed(self):
        self._all_scenes = list(self.song().scenes)
        self._selected_scene = self.song().view.selected_scene
        self._selected_scene_index = self._all_scenes.index(self._selected_scene)
        if self._page < 2:
            self._mira.scene_overview()

    def _init_leds(self):
        for index, loop in enumerate(LOOP_MAPPING):
            parameter = self._board.devices[loop].parameters[0]
            value = parameter.value
            led_value = 127 if value else 0
            self._led_status[1][index] = led_value
        return

    def handle_sysex(self, midi_bytes):
        self.midi_bytes = midi_bytes
        if midi_bytes[0] != 240:        # SysEx start
            return
        if midi_bytes[1] != 65:         # Roland Manufacturer ID
            return
        if midi_bytes[2] != 0:          # Device ID
            return
        if midi_bytes[3] != 114:        # Model ID
            return
        if midi_bytes[4] != 18:         # Command ID
            return

        bank = midi_bytes[5]
        pedal = midi_bytes[6]
        value = midi_bytes[7]
        body = [bank, pedal, value]

        # Debug
        self.log_message(f"\nReceived SysEx: {midi_bytes}\nbank {bank}, pedal {pedal}, value {value}")

        checksum = midi_bytes[-2]

        check_checksum = (128 - ((bank + pedal + value) % 128)) % 128

        if checksum != check_checksum:  # Checksum
            return

        if midi_bytes[-1] == 247:       # Return list at end of message
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

    def _on_param_changed(self):
        led_status = 0 if self.device.value == 0 else 127
        self.led_status(0, led_status)

    def _page_move(self, direction):
        if not MIN_PAGE <= self._page + direction <= MAX_PAGE:
            return
        self._page += direction
        self.leds_off()
        self.leds_recall()
        self.display(1, "")
        self.display(0, self._page)
        self.show_message(f"Page {self._page}")
        self.log_message(f"Page changed to {self._page}")

        if self._page < 2:
            self._mira.scene_overview()
            self._mira.highlight_parameter(-1)
            return
        if self._page == 2:
            self._mira.page_2()
            self._mira.highlight_parameter(-1)
            return

    def toggle_device(self, body):
        pedal_loops = self._board.devices
        if body[1] >= len(LOOP_MAPPING):
            return
        pedal_loop = pedal_loops[LOOP_MAPPING[body[1]]]
        if pedal_loop.parameters[0].value == 0:
            if str(LOOP_MAPPING[body[1]]) in HIGHLIGHT_NOTES:
                self._send_midi((0x9F, HIGHLIGHT_NOTES[str(LOOP_MAPPING[body[1]])], 127))
            pedal_loop.parameters[0].value = 1 
            return
        pedal_loop.parameters[0].value = 0 
        return

    def volume_control(self, value):
        parameter = self._board.devices[LOOP_VOLUME].parameters[1]
        parameter.value = value

    def favorite_parameter(self, body):
        pedal = body[1]
        parameter = self._board.devices[LOOP_MAPPING[pedal]].parameters[FAVORITE_PARAMETERS[pedal]]
        self._favorite_parameter_pedal = pedal
        self._favorite_parameter = parameter
        self.leds_off()
        self.led_status(pedal, 127)
        return

    def parameter_control(self, body):
        # Map expression pedal to parameter_control selected parameter
        if body[0] == 0 and body[1] == 13 and self._parameter_control_selected_parameter is not None:
            self._parameter_control_selected_parameter.value = body[2]
            return

        # Map CTL pedal to exit parameter_control mode
        if body == [0, 12, 0]:
            return # Ignore releasing
        if body == [0, 12, 127] and self._parameter_control_blink is not None: 
            self._parameter_control = None
            self._parameter_control_selected = None
            self._parameter_control_selected_pedal = None
            self._parameter_control_selected_parameter = None
            self._parameter_control_chains = None
            self._parameter_control_selected_chain = None
            self._parameter_control_selected_chain_index = None
            self._parameter_control_blink.kill()
            self._parameter_control_blink = None
            self.leds_off()
            self.flash_led(12)
            self._mira.page_2()
            self._mira.highlight_parameter(-1)
            return

        # Map bank up pedal to select different chains
        if body == [0, 10, 127] and self._parameter_control_selected_chain_index is not None and self._parameter_control_chains is not None:
            if self._parameter_control_selected_chain_index <= 0:
                return
            self._board.devices[self._parameter_control].view.selected_chain = self._parameter_control_chains[self._parameter_control_selected_chain_index - 1]
            self._parameter_control_selected_chain_index -= 1
            self.flash_led(10)
            return
        # Map bank down pedal to select different chains
        if body == [0, 11, 127] and self._parameter_control_selected_chain_index is not None and self._parameter_control_chains is not None:
            if self._parameter_control_selected_chain_index >= len(self._parameter_control_chains):
                return
            self._board.devices[self._parameter_control].view.selected_chain = self._parameter_control_chains[self._parameter_control_selected_chain_index + 1]
            self._parameter_control_selected_chain_index += 1
            self.flash_led(11)
            return

        # Initialize parameter_control mode with blinking
        if not self._parameter_control_selected and self._parameter_control_blink is None:
            self._favorite_parameter = None
            self._favorite_parameter_pedal = None
            self._parameter_control_chains = list(self._board.devices[self._parameter_control].chains)
            self._parameter_control_selected_chain = self._board.devices[self._parameter_control].view.selected_chain
            self._parameter_control_selected_chain_index = self._parameter_control_chains.index(self._board.devices[self._parameter_control].view.selected_chain)
            self.log_message(self._parameter_control_selected_chain)
            self.blink_leds_value = 127
            self.blink_leds()
            self._parameter_control_blink = self._tasks.add(Task.loop(Task.sequence(Task.wait(0.5), Task.run(self.blink_leds))))
            self._mira.parameter_control()
            self._mira.highlight_parameter(-1)
            return

        # Map pedals 1-4 and 6-9 to parameters (macros)
        if body[0] == 0 and 0 <= body[1] < 9 and body[1] != 4 and body[2] == 127:
            parameter_index = (body[1] - 4) if body[1] >= 5 else body[1] + 5
            self._parameter_control_selected = body[1]
            self._parameter_control_selected_parameter = self._board.devices[self._parameter_control].parameters[parameter_index]

            self.show_message(f"{self._board.devices[self._parameter_control].name} - {self._parameter_control_selected_parameter.name}")
            self.led_status(body[1], 127)
            self._mira.highlight_parameter(body[1])

    def tap_tempo(self):
        self.song().tap_tempo()

    def start_button(self):
        self.song().start_playing()

    def stop_button(self):
        self.song().stop_playing()

    def stop_all(self):
        self.song().stop_all_clips()

    def start_scene(self):
        self._selected_scene.fire()
        self.move_scene(1)
        self._fired_scene = self._selected_scene
        self._mira.scene_overview()
        self.show_message(f"Fired: {self._selected_scene.name}")
    
    def move_scene(self, direction):
        new_index = self._selected_scene_index + direction 
        if 0 <= new_index < len(self._all_scenes):
            self.song().view.selected_scene = self._all_scenes[new_index]
            new_name = self._all_scenes[new_index].name
            self.show_message(f"Scene: {new_name}")
        return

    def toggle_click(self):
        self.song().metronome = not self.song().metronome
        return


    def page_0(self, body):
        # Page UP
        if body == [0, 10, 127]:
            self._page_move(1)
            self.flash_led(10)
            if self._preset_store_blinking_led is not None:
                self._preset_store_blinking_led.kill()
                self._preset_store_blinking_led = None
            return
        # Page DOWN 
        if body == [0, 11, 127]:
            self._page_move(-1)
            self.flash_led(11)
            if self._preset_store_blinking_led is not None:
                self._preset_store_blinking_led.kill()
                self._preset_store_blinking_led = None
            return
        # Expression pedal calls volume_control
        if body[1] == 13:
            self.volume_control(body[2])
            return
        # CTL button calls tap_tempo
        if body == [0, 12, 127]:
            if self._preset_store_blinking_led is not None:
                self._preset_store_blinking_led.kill()
                self._preset_store_blinking_led = None
                self.show_message("Cancelled saving preset!")
                self.led_status(7, 0)
                return
            self.tap_tempo()
            self.flash_led(12)
            return
        # Ableton "start" button
        if body == [0, 0, 127]:
            self.start_button()
            return
        # Ableton "stop" button and stop all clips
        if body == [0, 1, 127]:
            self.stop_button()
            self.stop_all()
            self.flash_led(1)
            return
        # Ableton start scene
        if body == [0, 2, 127]:
            self.start_scene()
            self.flash_led(2)
            return
        # Ableton scene down
        if body == [0, 3, 127]:
            self.move_scene(1)
            self.flash_led(3)
            return
        # Ableton scene up
        if body == [0, 4, 127]:
            self.move_scene(-1)
            self.flash_led(4)
            return
        # Ableton click on/off 
        if body == [0, 5, 127]:
            self.toggle_click()
            return
        # Start scene and stop immediately (recall preset)
        if body == [0, 6, 127]:
            enable_metronome = False
            if self._metronome_state:
                self._tasks.add(
                    Task.sequence(
                        Task.run(self.toggle_click),
                        Task.run(self.start_scene),
                        Task.wait(0.1),
                        Task.run(self.stop_button),
                        Task.run(self.stop_all),
                        Task.run(self.toggle_click)
                    )
                )
                return
            self._tasks.add(
                Task.sequence(
                    Task.run(self.start_scene),
                    Task.wait(0.1),
                    Task.run(self.stop_button),
                    Task.run(self.stop_all),
                )
            )
            self.flash_led(6)
            return
        # Store preset
        if body == [0, 7, 127]:
            self._store_preset()
            self.flash_led(7)
            return
        # ForScore prev page
        if body == [0, 8, 127]:
            self._tasks.add(
                Task.sequence(
                    Task.run(lambda: self._send_midi((0xCF, FORSCORE_PREV_PAGE))),
                    Task.run(lambda: self.flash_led(8))
                )
            )
            return
        # ForScore next page
        if body == [0, 9, 127]:
            self._tasks.add(
                Task.sequence(
                    Task.run(lambda: self._send_midi((0xCF, FORSCORE_NEXT_PAGE))),
                    Task.run(lambda: self.flash_led(9))
                )
            )
            return

    def page_1(self, body):
        # Page UP
        if body == [0, 10, 127]:
            self._page_move(1)
            self.flash_led(10)
            return
        # Page DOWN 
        if body == [0, 11, 127]:
            self._page_move(-1)
            self.flash_led(11)
            return
        # Expression pedal calls volume_control
        if body[1] == 13:
            self.volume_control(body[2])
            return
        # CTL button calls tap_tempo
        if body == [0, 12, 127]:
            self.tap_tempo()
            self.flash_led(12)
            return
        # Toggle Device On/Off for pedals 1 thru 10
        if body[0] == 0 and 0 <= body[1] < 10 and body[2] == 127:
            self.toggle_device(body)
            return

    def page_2(self, body):
        # Page UP
        if body == [0, 10, 127]:
            self._favorite_parameter = None
            self._favorite_parameter_pedal = None
            self._page_move(1)
            self.flash_led(10)
            return
        # Page DOWN 
        if body == [0, 11, 127]:
            self._favorite_parameter = None
            self._favorite_parameter_pedal = None
            self._page_move(-1)
            self.flash_led(11)
            return        
        # Expression pedal calls volume_control
        if body[1] == 13 and self._favorite_parameter is None and self._parameter_control is None:
            self.volume_control(body[2])
            return
        # Device full parameter mode
        if self._favorite_parameter and body[0] == 0 and body[1] == self._favorite_parameter_pedal and body[2] == 127:
            self._parameter_control = LOOP_MAPPING[body[1]]
            self.parameter_control(body)
            return
        # Exit favorite parameter control
        if body == [0, 12, 127] and self._favorite_parameter is not None:
            self._favorite_parameter = None
            self._favorite_parameter_pedal = None
            self.leds_off()
            self.flash_led(12)
            self._mira.highlight_parameter(-1)
            return
        # Control favorite parameter when selected with pedal
        if self._favorite_parameter and body[0] == 0 and body[1] == 13:
            self._favorite_parameter.value = body[2]
            return
        # Device favorite parameter mode
        if body[0] == 0 and 0 <= body[1] < 10 and body[2] == 127:
            self.favorite_parameter(body)
            self._mira.highlight_parameter(body[1])
            return


    def disconnect(self):
        """Clean up when the script is unloaded."""
        self.log_message("(FC200) Removing all listeners...")

        # Remove listeners for page_0 (is_playing, metronome)
        if self.song().is_playing_has_listener(self._on_is_playing_changed):
            self.song().remove_is_playing_listener(self._on_is_playing_changed)
        if self.song().metronome_has_listener(self._on_metronome_changed):
            self.song().remove_metronome_listener(self._on_metronome_changed)
        if self.song().view.selected_scene_has_listener(self._on_selected_scene_changed):
            self.song().view.remove_selected_scene_listener(self._on_selected_scene_changed)

        if self._board.devices[LOOP_VOLUME].parameters[1].value_has_listener(self._highlight_tuner):
            self._board.devices[LOOP_VOLUME].parameters[1].remove_value_listener(self._highlight_tuner)

        if self._track.playing_slot_index_has_listener(self._load_preset):
            self._track.remove_playing_slot_index_listener(self._load_preset)

        # Remove listeners for page_1 (device_on)
        for param, callback in self._observed_params:
            if param.value_has_listener(callback):
                param.remove_value_listener(callback)

        self._observed_params = []

        self.log_message("--- MyCustomSysEx Script Unloaded ---")
        super(FC200, self).disconnect()


