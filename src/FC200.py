
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
from .SpecialMixerComponent import SpecialMixerComponent
from .SpecialTransportComponent import SpecialTransportComponent
from .SpecialSessionComponent import SpecialSessionComponent
from .SpecialZoomingComponent import SpecialZoomingComponent
from .SpecialViewControllerComponent import DetailViewControllerComponent
from .MIDI_Map import *


MIN_PAGE = 0
MAX_PAGE = 2
LOOP_MAPPING = [0, 1, 2, 3, 4, 6, 7, 8, 9]
LOOP_VOLUME = 2

class FC200(ControlSurface):
    def __init__(self, c_instance):
        super(FC200, self).__init__(c_instance)

        self._page = 1
        self._board = self.song().tracks[0].devices[0].chains[0]

        self._observed_params = []
        self._listeners()

        self._led_status = {}
        for p in range(MIN_PAGE, MAX_PAGE + 1):
            self._led_status[p] = {}
        
        # Log to the Ableton Log.txt file
        self.log_message("--- FC200 Script Loaded ---")

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

    def _listeners(self):
        def update_led(pedal, loop):
            self.log_message(f"parameter {loop} changed, updating LED {pedal}")
            if self._page != 1:
                return
            value = self._observed_params[pedal][0]
            led_value = 127 if str(value) == "On" else 0
            self.led_status(pedal, led_value)
            self._led_status[self._page][pedal] = led_value 
            return

        for index, loop in enumerate(LOOP_MAPPING):
            parameter = self._board.devices[loop].parameters[0]

            callback = lambda i=index, l=loop: update_led(i, l)

            if not parameter.value_has_listener(callback):
                parameter.add_value_listener(callback)
                self._observed_params.append((parameter, callback))
        self.log_message(f"Added listeners for {len(self._observed_params)} devices")
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

    def _page_up(self):
        if self._page == MAX_PAGE:
            return
        self._page += 1
        self.leds_off()
        self.leds_recall()
        self.log_message(f"Page changed to {self._page}")
    def _page_down(self):
        if self._page == MIN_PAGE:
            return
        self._page -= 1
        self.leds_off()
        self.leds_recall()
        self.log_message(f"Page changed to {self._page}")

    def toggle_device(self, body):
        pedal_loops = self._board.devices
        if body[1] >= len(LOOP_MAPPING):
            return
        pedal_loop = pedal_loops[LOOP_MAPPING[body[1]]]
        pedal_loop.parameters[0].value = 0 if pedal_loop.parameters[0].value == 1 else 1
        return

    def page_0(self, body):
        # Page UP
        if body == [0, 10, 127]:
            self._page_up()
            return
        # Page DOWN 
        if body == [0, 11, 127]:
            self._page_down()
            return

    def page_1(self, body):
        # Page UP
        if body == [0, 10, 127]:
            self._page_up()
            return
        # Page DOWN 
        if body == [0, 11, 127]:
            self._page_down()
            return
        # Toggle Device On/Off for pedals 1 thru 10
        if 0 <= body[1] < 10 and body[2] == 127:
            self.toggle_device(body)
            return

    def page_2(self, body):
        # Page UP
        if body == [0, 10, 127]:
            self._page_up()
            return
        # Page DOWN 
        if body == [0, 11, 127]:
            self._page_down()
            return



    def disconnect(self):
        """Clean up when the script is unloaded."""
        self.log_message("(FC200) Removing all listeners...")
        for param, callback in self._observed_params:
            if param.value_has_listener(callback):
                param.remove_value_listener(callback)

        self._observed_params = []

        self.log_message("--- MyCustomSysEx Script Unloaded ---")
        super(FC200, self).disconnect()


# class FC200(ControlSurface):   # Make sure you update the name
#     __doc__ = " Script for YourControllerName in APC emulation mode "   # Make sure you update the name
#
#     _active_instances = []
#
#     def _combine_active_instances():
#         track_offset = 0
#         scene_offset = 0
#         for instance in FC200._active_instances:   # Make sure you update the name
#             instance._activate_combination_mode(track_offset, scene_offset)
#             track_offset += instance._session.width()
#     _combine_active_instances = staticmethod(_combine_active_instances)
#
#     def __init__(self, c_instance):
#         ControlSurface.__init__(self, c_instance)
#         # self.set_suppress_rebuild_requests(True)
#         with self.component_guard():
#             self._note_map = []
#             self._ctrl_map = []
#             self._load_MIDI_map()
#             self._session = None
#             self._session_zoom = None
#             self._mixer = None
#             self._setup_session_control()
#             self._setup_mixer_control()
#             self._session.set_mixer(self._mixer)
#             self._setup_device_and_transport_control()
#             self.set_highlighting_session_component(self._session)
#             # self.set_suppress_rebuild_requests(False)
#         self._pads = []
#         self._load_pad_translations()
#         self._do_combine()
#
#     def handle_sysex(self, midi_bytes):
#         # midi_bytes arrives as a tuple of integers
#         # Example: (240, 0, 32, 45, 1, 247)
#
#         # 1. Validation: Is this the right length?
#         if len(midi_bytes) < 5:
#             return
#
#         # 2. Filtering: Is this meant for my script?
#         # Typically you check the Manufacturer ID (bytes 1-3)
#         if midi_bytes[1:3] == (0x00, 0x21):
#             self.log_message("--- SysEx Received ---")
#              # self._process_custom_logic(midi_bytes)
#
#     def disconnect(self):
#         self._note_map = None
#         self._ctrl_map = None
#         self._pads = None
#         self._do_uncombine()
#         self._shift_button = None
#         self._session = None
#         self._session_zoom = None
#         self._mixer = None
#         ControlSurface.disconnect(self)
#
#     def _do_combine(self):
#         if self not in FC200._active_instances:    # Make sure you update the name
#             FC200._active_instances.append(self)   # Make sure you update the name
#             FC200._combine_active_instances()  # Make sure you update the name
#
#     def _do_uncombine(self):
#         if (self in FC200._active_instances) and FC200._active_instances.remove(self):    # Make sure you update the name
#             self._session.unlink()
#             FC200._combine_active_instances()  # Make sure you update the name
#
#     def _activate_combination_mode(self, track_offset, scene_offset):
#         if TRACK_OFFSET != -1:
#             track_offset = TRACK_OFFSET
#         if SCENE_OFFSET != -1:
#             scene_offset = SCENE_OFFSET
#         self._session.link_with_track_offset(track_offset, scene_offset)
#
#     def _setup_session_control(self):
#         is_momentary = True
#         self._session = SpecialSessionComponent(TSB_X, TSB_Y)   # Track selection box size (X,Y) (horizontal, vertical).
#         self._session.name = 'Session_Control'
#         self._session.set_track_bank_buttons(self._note_map[SESSIONRIGHT], self._note_map[SESSIONLEFT])
#         self._session.set_scene_bank_buttons(self._note_map[SESSIONDOWN], self._note_map[SESSIONUP])
#         self._session.set_select_buttons(self._note_map[SCENEDN], self._note_map[SCENEUP])
#         # range(tsb_x) is the horizontal count for the track selection box
#         self._scene_launch_buttons = [self._note_map[SCENELAUNCH[index]] for index in range(TSB_X)]
#         # range(tsb_y) Range value is the track selection
#         self._track_stop_buttons = [self._note_map[TRACKSTOP[index]] for index in range(TSB_Y)]
#         self._session.set_stop_all_clips_button(self._note_map[STOPALLCLIPS])
#         self._session.set_stop_track_clip_buttons(tuple(self._track_stop_buttons))
#         self._session.selected_scene().name = 'Selected_Scene'
#         self._session.selected_scene().set_launch_button(self._note_map[SELSCENELAUNCH])
#         self._session.set_slot_launch_button(self._note_map[SELCLIPLAUNCH])
#         for scene_index in range(TSB_Y):    # Change range() value to set the vertical count for track selection box
#             scene = self._session.scene(scene_index)
#             scene.name = 'Scene_' + str(scene_index)
#             button_row = []
#             scene.set_launch_button(self._scene_launch_buttons[scene_index])
#             scene.set_triggered_value(2)
#             for track_index in range(TSB_X):    # Change range() value to set the horizontal count for track selection box
#                 button = self._note_map[CLIPNOTEMAP[scene_index][track_index]]
#                 button_row.append(button)
#                 clip_slot = scene.clip_slot(track_index)
#                 clip_slot.name = str(track_index) + '_Clip_Slot_' + str(scene_index)
#                 clip_slot.set_launch_button(button)
#         self._session_zoom = SpecialZoomingComponent(self._session)
#         self._session_zoom.name = 'Session_Overview'
#         self._session_zoom.set_nav_buttons(self._note_map[ZOOMUP], self._note_map[ZOOMDOWN], self._note_map[ZOOMLEFT], self._note_map[ZOOMRIGHT])
#
#     def _setup_mixer_control(self):
#
#         is_momentary = True
#         self._mixer = SpecialMixerComponent(8)
#         self._mixer.name = 'Mixer'
#         self._mixer.master_strip().name = 'Master_Channel_Strip'
#         self._mixer.master_strip().set_select_button(self._note_map[MASTERSEL])
#         self._mixer.selected_strip().name = 'Selected_Channel_Strip'
#         self._mixer.set_select_buttons(self._note_map[TRACKRIGHT], self._note_map[TRACKLEFT])
#         self._mixer.set_crossfader_control(self._ctrl_map[CROSSFADER])
#         self._mixer.set_prehear_volume_control(self._ctrl_map[CUELEVEL])
#         self._mixer.master_strip().set_volume_control(self._ctrl_map[MASTERVOLUME])
#         self._mixer.selected_strip().set_arm_button(self._note_map[SELTRACKREC])
#         self._mixer.selected_strip().set_solo_button(self._note_map[SELTRACKSOLO])
#         self._mixer.selected_strip().set_mute_button(self._note_map[SELTRACKMUTE])
#         for track in range(8):
#             # My guess is that altering the range here will allow you to alter the range of mixer tracks
#             # So if you had a 16 fader mixer, this would come in handy.
#             strip = self._mixer.channel_strip(track)
#             strip.name = 'Channel_Strip_' + str(track)
#             strip.set_arm_button(self._note_map[TRACKREC[track]])
#             strip.set_solo_button(self._note_map[TRACKSOLO[track]])
#             strip.set_mute_button(self._note_map[TRACKMUTE[track]])
#             strip.set_select_button(self._note_map[TRACKSEL[track]])
#             strip.set_volume_control(self._ctrl_map[TRACKVOL[track]])
#             strip.set_pan_control(self._ctrl_map[TRACKPAN[track]])
#             strip.set_send_controls((self._ctrl_map[TRACKSENDA[track]], self._ctrl_map[TRACKSENDB[track]], self._ctrl_map[TRACKSENDC[track]]))
#             strip.set_invert_mute_feedback(True)
#
#     def _setup_device_and_transport_control(self):
#         is_momentary = True
#         self._device = DeviceComponent()
#         self._device.name = 'Device_Component'
#         device_bank_buttons = []
#         device_param_controls = []
#         for index in range(8):
#             device_param_controls.append(self._ctrl_map[PARAMCONTROL[index]])
#             device_bank_buttons.append(self._note_map[DEVICEBANK[index]])
#         if None not in device_bank_buttons:
#             self._device.set_bank_buttons(tuple(device_bank_buttons))
#         if None not in device_param_controls:
#             self._device.set_parameter_controls(tuple(device_param_controls))
#         self._device.set_on_off_button(self._note_map[DEVICEONOFF])
#         self._device.set_bank_nav_buttons(self._note_map[DEVICEBANKNAVLEFT], self._note_map[DEVICEBANKNAVRIGHT])
#         self._device.set_lock_button(self._note_map[DEVICELOCK])
#         self.set_device_component(self._device)
#
#         detail_view_toggler = DetailViewControllerComponent()
#         detail_view_toggler.name = 'Detail_View_Control'
#         detail_view_toggler.set_device_clip_toggle_button(self._note_map[CLIPTRACKVIEW])
#         detail_view_toggler.set_detail_toggle_button(self._note_map[DETAILVIEW])
#         detail_view_toggler.set_device_nav_buttons(self._note_map[DEVICENAVLEFT], self._note_map[DEVICENAVRIGHT])
#
#         transport = SpecialTransportComponent()
#         transport.name = 'Transport'
#         transport.set_play_button(self._note_map[PLAY])
#         transport.set_stop_button(self._note_map[STOP])
#         transport.set_record_button(self._note_map[REC])
#         transport.set_nudge_buttons(self._note_map[NUDGEUP], self._note_map[NUDGEDOWN])
#         transport.set_undo_button(self._note_map[UNDO])
#         transport.set_redo_button(self._note_map[REDO])
#         transport.set_tap_tempo_button(self._note_map[TAPTEMPO])
#         transport.set_quant_toggle_button(self._note_map[RECQUANT])
#         transport.set_overdub_button(self._note_map[OVERDUB])
#         transport.set_metronome_button(self._note_map[METRONOME])
#         transport.set_tempo_control(self._ctrl_map[TEMPOCONTROL])
#         transport.set_loop_button(self._note_map[LOOP])
#         transport.set_seek_buttons(self._note_map[SEEKFWD], self._note_map[SEEKRWD])
#         transport.set_punch_buttons(self._note_map[PUNCHIN], self._note_map[PUNCHOUT])
#         # transport.set_song_position_control(self._ctrl_map[SONGPOSITION]) #still not implemented as of Live 8.1.6
#
#     def _on_selected_track_changed(self):
#         ControlSurface._on_selected_track_changed(self)
#         track = self.song().view.selected_track
#         device_to_select = track.view.selected_device
#         if device_to_select is None and len(track.devices) > 0:
#             device_to_select = track.devices[0]
#         if device_to_select is not None:
#             self.song().view.select_device(device_to_select)
#         self._device_component.set_device(device_to_select)
#
#     def _load_pad_translations(self):
#         if -1 not in DRUM_PADS:
#             pad = []
#             for row in range(4):
#                 for col in range(4):
#                     pad = (col, row, DRUM_PADS[row*4 + col], PADCHANNEL,)
#                     self._pads.append(pad)
#             self.set_pad_translations(tuple(self._pads))
#
#     def _load_MIDI_map(self):
#         is_momentary = True
#         for note in range(128):
#             button = ButtonElement(is_momentary, MESSAGETYPE, BUTTONCHANNEL, note)
#             button.name = 'Note_' + str(note)
#             self._note_map.append(button)
#         self._note_map.append(None)     # add None to the end of the list, selectable with [-1]
#         if MESSAGETYPE == MIDI_CC_TYPE and BUTTONCHANNEL == SLIDERCHANNEL:
#             for ctrl in range(128):
#                 self._ctrl_map.append(None)
#         else:
#             for ctrl in range(128):
#                 control = SliderElement(MIDI_CC_TYPE, SLIDERCHANNEL, ctrl)
#                 control.name = 'Ctrl_' + str(ctrl)
#                 self._ctrl_map.append(control)
#             self._ctrl_map.append(None)
