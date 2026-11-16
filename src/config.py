import os


class Settings:
    PRESET_FOLDER: str = os.path.expanduser("~/Music/Ableton/User Library/eGit presets")
    FORCE_SYSEX: bool = True
    MIN_PAGE: int = 0
    MAX_PAGE: int = 2
    LOOP_MAPPING: list[int] = [0, 1, 2, 3, 4, 6, 7, 8, 9]
    LOOP_VOLUME: int = 5
    LOOP_FREEZE: int = 10
    FAVORITE_PARAMETERS: list[int] = [6, 1, 1, 1, 1, 1, 2, 1, 2, 1]
    # Tuner: track.devices[TUNER_RACK].chains[TUNER_CHAIN].devices[TUNER_DEVICE]
    TUNER_RACK: int = 1
    TUNER_CHAIN: int = 1
    TUNER_DEVICE: int = 1
    TUNER_TOLERANCE: float = 2  # cents either side that count as in tune
    # Tuner `level` above this: a note sounds (silence 0, a string ~0.2). Only used when
    # the tuner rack has no "Threshold" macro (that one sets it: 0..127 for 0..1)
    TUNER_LEVEL_THRESHOLD: float = 0.2
    TUNER_HOLD: float = 3.0  # seconds the tuner stays after the note stops
    FORSCORE_PREV_PAGE: int = 0
    FORSCORE_NEXT_PAGE: int = 1
    FORSCORE_PREV_SCORE: int = 2
    FORSCORE_NEXT_SCORE: int = 3
