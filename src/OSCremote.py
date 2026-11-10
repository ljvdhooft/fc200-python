import socket
import struct

class OSCremote:
    def __init__(self, ip: str, port: int) -> None:
        self.ip = ip
        self.port = port
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def _send_osc(self, address: str, value: str | int | float) -> None:
        # Basic OSC string padding (must be multiple of 4 bytes)
        def osc_string(s: str) -> bytes:
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

