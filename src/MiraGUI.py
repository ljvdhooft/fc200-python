from .config import *
import socket
import struct

class MiraGUI:
    def __init__(self, script, ip="127.0.0.1", port=8001):
        self._script = script
        self.ip = ip
        self.port = port
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def _send_osc(self, address, value):
        # Basic OSC string padding (must be multiple of 4 bytes)
        def osc_string(s):
            return s.encode('utf-8') + b'\x00' * (4 - len(s) % 4 or 4)

        # Build message: [Address][Type Tag][Value]
        msg = osc_string(address)
        if isinstance(value, str):
            msg += osc_string(",s") + osc_string(value)
        elif isinstance(value, int):
            msg += osc_string(",i") + struct.pack(">i", value)
        elif isinstance(value, float):
            msg += osc_string(",f") + struct.pack(">f", value)

        try:
            self.sock.sendto(msg, (self.ip, self.port))
        except:
            pass

    def highlight_parameter(self, index):
        for i in range(0, 10):
            self._send_osc(f"/parameters/{i}/highlight", False)
        if index < 0:
            return
        index = (((index + 5) * (index < 5)) + ((index - 5) * (index >= 5)))
        self._script.log_message(index)
        self._send_osc(f"/parameters/{index}/highlight", True)

    def scene_overview(self):
        self._send_osc("/window", "scene_overview")
        cur_index = self._script._selected_scene_index
        cur = self._script._selected_scene


        if cur_index - 3 < 0:
            self._send_osc("/scenes/prev3/name", "")
            self._send_osc("/scenes/prev3/color", 0)
        else:
            prev3 = self._script.song().scenes[cur_index - 3]
            self._send_osc("/scenes/prev3/name", prev3.name)
            self._send_osc("/scenes/prev3/color", prev3.color)
        if cur_index - 2 < 0:
            self._send_osc("/scenes/prev2/name", "")
            self._send_osc("/scenes/prev2/color", 0)
        else:
            prev2 = self._script.song().scenes[cur_index - 2]
            self._send_osc("/scenes/prev2/name", prev2.name)
            self._send_osc("/scenes/prev2/color", prev2.color)
        if cur_index - 1 < 0:
            self._send_osc("/scenes/prev1/name", "")
            self._send_osc("/scenes/prev1/color", 0)
        else:
            prev1 = self._script.song().scenes[cur_index - 1]
            self._send_osc("/scenes/prev1/name", prev1.name)
            self._send_osc("/scenes/prev1/color", prev1.color)

        if cur_index + 1 >= len(self._script._all_scenes):
            self._send_osc("/scenes/next1/name", "")
            self._send_osc("/scenes/next1/color", 0)
        else:
            next1 = self._script.song().scenes[cur_index + 1]
            self._send_osc("/scenes/next1/name", next1.name)
            self._send_osc("/scenes/next1/color", next1.color)
        if cur_index + 2 >= len(self._script._all_scenes):
            self._send_osc("/scenes/next2/name", "")
            self._send_osc("/scenes/next2/color", 0)
        else:
            next2 = self._script.song().scenes[cur_index + 2]
            self._send_osc("/scenes/next2/name", next2.name)
            self._send_osc("/scenes/next2/color", next2.color)
        if cur_index + 3 >= len(self._script._all_scenes):
            self._send_osc("/scenes/next3/name", "")
            self._send_osc("/scenes/next3/color", 0)
        else:
            next3 = self._script.song().scenes[cur_index + 3]
            self._send_osc("/scenes/next3/name", next3.name)
            self._send_osc("/scenes/next3/color", next3.color)

        self._send_osc("/scenes/cur/name", cur.name)
        self._send_osc("/scenes/cur/color", cur.color)
        fired_scene = self._script._fired_scene
        if fired_scene is None:
            self._send_osc("/scenes/fired", "")
        else:
            self._send_osc("/scenes/fired/name", fired_scene.name)
            self._send_osc("/scenes/fired/color", fired_scene.color)
        return

    def page_2(self):
        self._send_osc("/window", "parameters")
        self._send_osc("/parameters/title/show/text", False)
        self._send_osc("/parameters/chains/show", False)
        self._send_osc("/parameters/title/text/text", "path")
        self._send_osc("/parameters/title/text/value", "path")
        for i, l in enumerate(LOOP_MAPPING):
            fav_par = FAVORITE_PARAMETERS[i]
            i = (((i + 5) * (i < 5)) + ((i - 5) * (i >= 5)))
            path = f"path live_set tracks {TRACK} devices {MAIN_DEVICE} chains 0 devices {l}"
            live_text_value_path = f"{path} parameters 0"
            live_dial_path = f"{path} parameters {fav_par}"
            self._send_osc(f"/parameters/{i}/text/text", path)
            self._send_osc(f"/parameters/{i}/text/value", live_text_value_path)
            self._send_osc(f"/parameters/{i}/dial", live_dial_path)
            self._send_osc(f"/parameters/{i}/show", True)
            self._send_osc(f"/parameters/{i}/show/text", True)

        for i in range(len(LOOP_MAPPING), (10 + (9 - len(LOOP_MAPPING)))):
            i = (((i + 5) * (i < 5)) + ((i - 5) * (i >= 5)))
            self._send_osc(f"/parameters/{i}/show", False)

    def parameter_control(self):
        path = f"path live_set tracks {TRACK} devices {MAIN_DEVICE} chains 0 devices {self._script._parameter_control}"
        live_text_value_path = f"{path} parameters 0"
        self._send_osc("/window", "parameters")
        self._send_osc("/parameters/title/show/text", True)
        self._send_osc("/parameters/title/text/text", path)
        self._send_osc("/parameters/title/text/value", live_text_value_path)
        self._send_osc("/parameters/chains/show", True)
        self._send_osc("/parameters/chains/path", path)
        for i in range(0, 9):
            if i == 4:
                continue
            live_dial_path = f"{path} parameters {((i + 1) * (i < 4) + (i * (i >= 4)))}"
            # i = (((i + 5) * (i < 5)) + ((i - 5) * (i >= 5)))
            self._send_osc(f"/parameters/{i}/text/text", "path")
            self._send_osc(f"/parameters/{i}/text/value","path")
            self._send_osc(f"/parameters/{i}/dial", live_dial_path)
            self._send_osc(f"/parameters/{i}/show", True)
            self._send_osc(f"/parameters/{i}/show/text", False)
        self._send_osc(f"/parameters/4/show", False)
        self._send_osc(f"/parameters/9/show", False)



