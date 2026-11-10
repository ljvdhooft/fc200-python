"""Roland Exclusive Messages for the FC-200 (manual pp. 39-44).

Only Data Set 1 (DT1) is used. Its body is a 2-byte address plus 1 data
byte: [address MSB, address LSB, data]. The address MSB selects an area of
the parameter address map. No Live imports, so it can be unit-tested.
"""

# Exclusive status, Roland manufacturer ID, device ID, model ID (FC-200), DT1
HEADER = (0xF0, 0x41, 0x00, 0x72, 0x12)
EOX = 0xF7

# Parameter address map: address MSB
PEDAL_STATUS = 0x00         # inbound: pedal operated
LED_STATUS = 0x01
BANK_DISPLAY_STATUS = 0x02
MODE_STATUS = 0x03

# Pedal Status / LED Status: address LSB
(PEDAL_1, PEDAL_2, PEDAL_3, PEDAL_4, PEDAL_5,
 PEDAL_6, PEDAL_7, PEDAL_8, PEDAL_9, PEDAL_10) = range(0x0A)
PEDAL_UP = 0x0A
PEDAL_DOWN = 0x0B
PEDAL_CTL = 0x0C
EXP_PEDAL = 0x0D
# Extra pedals plugged into the FOOT SW/EXP 1-6 jacks on the back
(FOOT_SW_EXP_1, FOOT_SW_EXP_2, FOOT_SW_EXP_3,
 FOOT_SW_EXP_4, FOOT_SW_EXP_5, FOOT_SW_EXP_6) = range(0x0E, 0x14)

# Bank Display Status: address LSB
BANK_DISPLAY_RIGHT = 0x00
BANK_DISPLAY_LEFT = 0x01

# Mode Status: address LSB, and the data value for Exclusive Mode
MODE_CURRENT = 0x00         # sent by the FC-200 on power-up or mode change
MODE_SET = 0x01             # DT1 to this address changes the mode
MODE_EXCLUSIVE = 0x03

ON = 0x7F
OFF = 0x00

# Bank display segment bitmasks per character
SEGMENTS = {
    '1': 48,  '2': 91,  '3': 121, '4': 116, '5': 109,
    '6': 111, '7': 56,  '8': 127, '9': 125, '0': 63,
    'A': 126, 'B': 103, 'C': 15,  'D': 115, 'E': 79,
    'F': 78,  'G': 47,  'H': 118, 'I': 32,  'J': 51,
    'K': 110, 'L': 7,   'M': 107, 'N': 98,  'O': 99,
    'P': 94,  'Q': 124, 'R': 66,  'S': 109, 'T': 71,
    'U': 55,  'V': 35,  'W': 85,  'X': 118, 'Y': 117,
    'Z': 91,  ' ': 0
}


def checksum(body):
    return (128 - (sum(body) % 128)) % 128


def build(body):
    """Return the full DT1 message for an [address MSB, address LSB, data] body."""
    return HEADER + tuple(body) + (checksum(body), EOX)


def parse(midi_bytes):
    """Return [address MSB, address LSB, data] for a valid FC-200 DT1, else None."""
    if len(midi_bytes) != len(HEADER) + 5:
        return None
    if tuple(midi_bytes[:len(HEADER)]) != HEADER or midi_bytes[-1] != EOX:
        return None
    body = list(midi_bytes[5:8])
    if midi_bytes[8] != checksum(body):
        return None
    return body


def pressed(body, pedal):
    """True if body is the pedal being pressed down (not released)."""
    return body == [PEDAL_STATUS, pedal, ON]


def released(body, pedal):
    return body == [PEDAL_STATUS, pedal, OFF]


def number_pedal_pressed(body):
    """True if body is one of Pedals 1-10 being pressed down."""
    return body[0] == PEDAL_STATUS and PEDAL_1 <= body[1] <= PEDAL_10 and body[2] == ON


def changed(body, pedal):
    """True if body is a Pedal Status change of the pedal, with any value."""
    return body[0] == PEDAL_STATUS and body[1] == pedal


def segments(char):
    """Return the bank display bitmask for a character; 0 (off) if unsupported."""
    key = str(char).upper()
    if key == "SPACE":
        key = " "
    return SEGMENTS.get(key, 0)
