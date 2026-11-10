"""Roland FC200 SysEx protocol. No Live imports, so it can be unit-tested."""

# SysEx start, Roland manufacturer ID, device ID, model ID, command ID
HEADER = (240, 65, 0, 114, 18)
END = 247

# Banks (first byte of the body)
BANK_PEDAL = 0      # inbound pedal events
BANK_LED = 1
BANK_DISPLAY = 2
BANK_MODE = 3

# Pedal IDs in BANK_PEDAL; 0-9 are the numbered pedals
BANK_UP = 10
BANK_DOWN = 11
CTL = 12
EXPR = 13
EXPR_2 = 14

# Digits of the 7-segment display
DISPLAY_RIGHT = 0
DISPLAY_LEFT = 1

ON = 127
OFF = 0

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
    """Return the full SysEx message for a [bank, pedal, value] body."""
    return HEADER + tuple(body) + (checksum(body), END)


def parse(midi_bytes):
    """Return [bank, pedal, value] for a valid FC200 message, else None."""
    if len(midi_bytes) != len(HEADER) + 5:
        return None
    if tuple(midi_bytes[:len(HEADER)]) != HEADER or midi_bytes[-1] != END:
        return None
    body = list(midi_bytes[5:8])
    if midi_bytes[8] != checksum(body):
        return None
    return body


def segments(char):
    """Return the 7-segment bitmask for a character; 0 (off) if unsupported."""
    key = str(char).upper()
    if key == "SPACE":
        key = " "
    return SEGMENTS.get(key, 0)
