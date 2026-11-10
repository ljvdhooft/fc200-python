import os


class Settings:
    PRESET_FOLDER = os.path.expanduser("~/Music/Ableton/User Library/eGit presets")
    FORCE_SYSEX = True
    MIN_PAGE = 0
    MAX_PAGE = 2
    LOOP_MAPPING = [0, 1, 2, 3, 4, 6, 7, 8, 9]
    LOOP_VOLUME = 5
    LOOP_FREEZE = 10
    FAVORITE_PARAMETERS = [6, 1, 1, 1, 1, 1, 2, 1, 2, 1]
    # Tuner: track.devices[TUNER_RACK].chains[TUNER_CHAIN].devices[TUNER_DEVICE]
    TUNER_RACK = 1
    TUNER_CHAIN = 1
    TUNER_DEVICE = 1
    HIGHLIGHT_NOTES = {
            "tuner": 0,
            "board": 1,
            "0": 2
            }
    OSC_REMOTE_HOST = "127.0.0.1"
    OSC_REMOTE_PORT = 20022
    FORSCORE_PREV_PAGE = 0
    FORSCORE_NEXT_PAGE = 1
    FORSCORE_PREV_SCORE = 2
    FORSCORE_NEXT_SCORE = 3
