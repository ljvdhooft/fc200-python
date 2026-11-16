"""MIDI out to a CoreMIDI destination, for the `midi.send` hub command (protocol section 8).

Calls CoreMIDI through ctypes: pyobjc's CoreMIDI wrapper has no MIDISend, and
python-rtmidi has no wheel for the hub's Python. macOS only.
"""

from __future__ import annotations

import ctypes as c
import logging
from collections.abc import Callable
from typing import TypeGuard

log = logging.getLogger(__name__)

DESTINATION = "IAC Driver FC200 > Ableton"

_UTF8 = 0x08000100  # kCFStringEncodingUTF8


class _Packet(c.Structure):
    # MIDIPacket and MIDIPacketList are declared under #pragma pack(4)
    _pack_ = 4
    _layout_ = "ms"
    _fields_ = [("timeStamp", c.c_uint64), ("length", c.c_uint16), ("data", c.c_ubyte * 256)]


class _PacketList(c.Structure):
    _pack_ = 4
    _layout_ = "ms"
    _fields_ = [("numPackets", c.c_uint32), ("packet", _Packet * 1)]


def is_channel_message(data: object) -> TypeGuard[list[int]]:
    """One complete channel message: a status byte 0x80..0xEF and its data bytes."""
    if not isinstance(data, list) or not data or not all(isinstance(b, int) and not isinstance(b, bool) for b in data):
        return False
    status, rest = data[0], data[1:]
    length = 2 if 0xC0 <= status <= 0xDF else 3
    return 0x80 <= status <= 0xEF and len(data) == length and all(0 <= b <= 0x7F for b in rest)


class MidiOut:
    """Sends to a destination by display name; looked up on every send, so the port
    may come and go (IAC bus switched off and on) without restarting the hub."""

    def __init__(self, destination: str = DESTINATION) -> None:
        self.destination = destination
        self._port: c.c_uint32 | None = None
        self._cm: c.CDLL | None = None
        self._cf: c.CDLL | None = None
        self._host_time: Callable[[], int] | None = None

    def send(self, data: object) -> bool:
        if not is_channel_message(data):
            log.warning("midi.send: not one channel message, dropped: %r", data)
            return False
        self._open()
        assert self._cm is not None and self._port is not None and self._host_time is not None
        endpoint = self._find()
        if endpoint is None:
            log.warning("midi.send: no MIDI destination %r, dropped", self.destination)
            return False
        packets = _PacketList(numPackets=1)
        # The current host time, not 0 ("now"): a packet stamped 0 on an IAC bus stops
        # Live's MIDI track input from that bus until the port is switched off and on
        # (Live 12.4b17; Max's sends, stamped with the host time, don't)
        packets.packet[0].timeStamp = self._host_time()
        packets.packet[0].length = len(data)
        for i, byte in enumerate(data):
            packets.packet[0].data[i] = byte
        status = self._cm.MIDISend(self._port, endpoint, c.byref(packets))
        if status != 0:
            log.warning("midi.send: MIDISend failed (%s)", status)
            return False
        log.info("midi.send %s", " ".join(f"{b:02X}" for b in data))
        return True

    def _open(self) -> None:
        if self._port is not None:
            return
        cm = c.cdll.LoadLibrary("/System/Library/Frameworks/CoreMIDI.framework/CoreMIDI")
        cf = c.cdll.LoadLibrary("/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation")
        cf.CFStringCreateWithCString.restype = c.c_void_p
        cf.CFStringCreateWithCString.argtypes = [c.c_void_p, c.c_char_p, c.c_uint32]
        cf.CFStringGetCString.argtypes = [c.c_void_p, c.c_char_p, c.c_long, c.c_uint32]
        cf.CFRelease.argtypes = [c.c_void_p]
        cm.MIDIGetDestination.restype = c.c_uint32
        cm.MIDIGetDestination.argtypes = [c.c_ulong]
        cm.MIDIObjectGetStringProperty.argtypes = [c.c_uint32, c.c_void_p, c.POINTER(c.c_void_p)]
        cm.MIDIClientCreate.argtypes = [c.c_void_p, c.c_void_p, c.c_void_p, c.POINTER(c.c_uint32)]
        cm.MIDIOutputPortCreate.argtypes = [c.c_uint32, c.c_void_p, c.POINTER(c.c_uint32)]
        cm.MIDISend.argtypes = [c.c_uint32, c.c_uint32, c.POINTER(_PacketList)]
        libc = c.CDLL(None)
        libc.mach_absolute_time.restype = c.c_uint64
        client, port = c.c_uint32(), c.c_uint32()
        name = cf.CFStringCreateWithCString(None, b"FC200 Hub", _UTF8)
        try:
            if cm.MIDIClientCreate(name, None, None, c.byref(client)) != 0:
                raise OSError("MIDIClientCreate failed")
            if cm.MIDIOutputPortCreate(client, name, c.byref(port)) != 0:
                raise OSError("MIDIOutputPortCreate failed")
        finally:
            cf.CFRelease(name)
        self._cm, self._cf, self._port = cm, cf, port
        self._host_time = libc.mach_absolute_time

    def _find(self) -> int | None:
        assert self._cm is not None and self._cf is not None
        key = c.c_void_p.in_dll(self._cm, "kMIDIPropertyDisplayName")
        for i in range(self._cm.MIDIGetNumberOfDestinations()):
            endpoint = self._cm.MIDIGetDestination(i)
            name = c.c_void_p()
            if self._cm.MIDIObjectGetStringProperty(endpoint, key, c.byref(name)) != 0:
                continue
            buf = c.create_string_buffer(256)
            self._cf.CFStringGetCString(name, buf, 256, _UTF8)
            self._cf.CFRelease(name)
            if buf.value.decode() == self.destination:
                return int(endpoint)
        return None
