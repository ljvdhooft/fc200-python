## Ableton
Uses the `ableton-dev` skill — load it for any Live/Max/Remote Script/extension work.
- Live version pinned: 12.4b14
- Components:
  - MIDI Remote Script: `src/` (symlinked into Live User Library as `_FC200_SysEx_dev`; `_FC200_SysEx` points to the sibling `fc200-python-main` checkout)
  - M4L device: `virtual-pedal/FC200_virtual-pedal.maxpat` (built `FC200 Mira.amxd` symlinked at repo root)
- Protocol: none yet
- Integration tests: none yet

### What this does
Roland FC200 floor pedal → MIDI SysEx → `src/FC200.py` (a `ControlSurface`) drives an audio effect rack (found by its device name, "FC200 Pedalboard", on any track) to emulate a pedalboard, plus transport/session control. `src/SegmentEncoder.py` encodes characters for the pedal's 7-segment display.

### Preset system (shadow JSON + dummy clip)
A dummy audio clip on the guitar track's clip slots doubles as a preset slot — its name is the preset name:
- **Store** (`FC200._store_preset`): reads current values of all chain devices' parameters from the rack, writes them to `<PRESET_FOLDER>/_json/<clip name>.json`, and generates a matching `.alc` clip file (from `template.alc.xml`, patched via `xmltodict`) so the dummy clip is importable from Ableton's browser. Prompts for confirmation (blinking LED) if a preset with that name already exists.
- **Recall** (`FC200._load_preset`): fires on the track's `playing_slot_index` listener — when a clip is launched, it looks up `<clip name>.json` and re-applies the saved parameter values to the rack. No-ops if no shadow file matches.
- `PRESET_FOLDER` is set in `src/config.py` (currently an absolute path under Ableton's User Library — not portable across machines).
- The `.json` and `.alc` are a loosely coupled pair kept in sync only by this store flow; renaming a clip in Live does **not** rename its shadow file.

### OSC side-channel
`src/OSCremote.py` and `src/MiraGUI.py` each open their own outbound UDP/OSC socket (hand-rolled OSC packing, no library) — `OSCremote` talks to a standalone Max/MSP patch (the M4L-adjacent `virtual-pedal/FC200_virtual-pedal.maxpat`, or a standalone Max app built from it) which re-emits MIDI to external gear, e.g. page-turn commands to ForScore on iPad. `MiraGUI` drives a Mira/touch-OSC-style display. Ports/IPs are hardcoded constructor defaults (127.0.0.1:20022 and :8001) — no `protocol/` spec exists for these messages yet.
