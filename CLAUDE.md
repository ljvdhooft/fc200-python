## Ableton
Uses the `ableton-dev` skill — load it for any Live/Max/Remote Script/extension work.
- Live version pinned: 12.4b14
- Components:
  - MIDI Remote Script: `src/` (symlinked into Live User Library as `_FC200_SysEx_dev`; `_FC200_SysEx` points to the sibling `fc200-python-main` checkout)
  - Virtual pedal: `virtual-pedal/FC200_virtual-pedal.maxpat`, an air-gapped Max patch that emulates the FC-200 in Exclusive (SysEx) mode, for testing without the hardware. MIDI only (no OSC): in Live, select the Remote Script with MIDI in/out "from Max 1" / "to Max 1"; the patch uses the same virtual MIDI ports.
  - M4L device: `FC200 Mira.amxd` (repo root), a GUI for the script; to be refactored later
- Protocol: none yet
- Unit tests: `python3.11 -m unittest discover -s tests` (Live-free modules only)
- Type check: `mypy` (config in `mypy.ini`: Python 3.11 rules, skips vendored `xmltodict` and `MiraGUI`; mypy is installed system-wide, not in a venv)
- Integration tests: none yet

### What this does
Roland FC200 floor pedal → MIDI SysEx → `src/FC200.py` (a `ControlSurface`) drives an audio effect rack (found by its device name, "FC200 Pedalboard", on any track) to emulate a pedalboard, plus transport/session control. `src/roland_exclusive.py` (no Live imports) holds the Roland Exclusive (DT1) format, the FC-200 address map and the bank display segment encoding; `src/hardware.py` drives the LEDs, bank display and mode. Names follow the FC-200 manual (pp. 39-44, `~/Documents/02 DEV - Max/FC200 Programming/FC-200 manual.pdf`).

### Preset system (shadow JSON + dummy clip)
A dummy audio clip on the guitar track's clip slots doubles as a preset slot — its name is the preset name:
- **Store** (`FC200._store_preset`): reads current values of all chain devices' parameters from the rack, writes them to `<PRESET_FOLDER>/_json/<clip name>.json`, and generates a matching `.alc` clip file (from `template.alc.xml`, patched via `xmltodict`) so the dummy clip is importable from Ableton's browser. Prompts for confirmation (blinking LED) if a preset with that name already exists.
- **Recall** (`FC200._load_preset`): fires on the track's `playing_slot_index` listener — when a clip is launched, it looks up `<clip name>.json` and re-applies the saved parameter values to the rack. No-ops if no shadow file matches.
- `PRESET_FOLDER` is set in `src/config.py` (`~/Music/Ableton/User Library/eGit presets`, expanded per user).
- The `.json` and `.alc` are a loosely coupled pair kept in sync only by this store flow; renaming a clip in Live does **not** rename its shadow file.

### OSC side-channel
`src/OSCremote.py` and `src/MiraGUI.py` each open their own outbound UDP/OSC socket (hand-rolled OSC packing, no library). `OSCremote` host/port come from `config.Settings` (`OSC_REMOTE_HOST`/`OSC_REMOTE_PORT`, 127.0.0.1:20022); MiraGUI's :8001 is still a hardcoded default — no `protocol/` spec exists for these messages yet. `MiraGUI` drives a Mira/touch-OSC-style display.

`OSCremote` (UDP 20022) is how the script gets MIDI to ForScore and back into Live:

```
FC200.py ─OSC/UDP 20022─► standalone Max patch (OSC → MIDI; not in this repo)
  ─IAC "FC200 > Ableton"─► MIDI track in Live
       ├─ M4L "page_turner" (MIDI middleware, e.g. makes automation possible)
       └─ output → Network MIDI ─► ForScore on iPad
```

Why the detour: the Remote Script used to send this MIDI to Live directly, which caused feedback loops that crashed Live. Offloading the MIDI output to Max is the current fix — don't move it back into the Remote Script.
