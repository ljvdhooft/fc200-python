class SegmentEncoder:
    # We store the mapping in a dictionary for fast lookup
    MAP = {
        '1': 48,  '2': 91,  '3': 121, '4': 116, '5': 109,
        '6': 111, '7': 56,  '8': 127, '9': 125, '0': 63,
        'A': 126, 'B': 103, 'C': 15,  'D': 115, 'E': 79,
        'F': 78,  'G': 47,  'H': 118, 'I': 32,  'J': 51,
        'K': 110, 'L': 7,   'M': 107, 'N': 98,  'O': 99,
        'P': 94,  'Q': 124, 'R': 66,  'S': 109, 'T': 71,
        'U': 55,  'V': 35,  'W': 85,  'X': 118, 'Y': 117,
        'Z': 91,  ' ': 0
    }

    @classmethod
    def get_segments(cls, char):
        """
        Converts a character into the 7-segment bitmask.
        Returns 0 (off) if character is not supported.
        """
        # Convert to string and uppercase to match the map
        char_key = str(char).upper()
        
        # Handle "space" text explicitly if passed as a string
        if char_key == "SPACE":
            char_key = " "
            
        return cls.MAP.get(char_key, 0)
