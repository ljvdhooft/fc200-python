## Ableton
Uses the `ableton-dev` skill — load it for any Live/Max/Remote Script/extension work.
- Live version pinned: 12.4b14
- Components:
  - MIDI Remote Script: `src/` (symlinked into Live User Library as `_FC200_SysEx_dev`; `_FC200_SysEx` points to the sibling `fc200-python-main` checkout)
  - Virtual pedal: `virtual-pedal/FC200_virtual-pedal.maxpat`, an air-gapped Max patch that emulates the FC-200 in Exclusive (SysEx) mode, for testing without the hardware. MIDI only (no OSC): in Live, select the Remote Script with MIDI in/out "from Max 1" / "to Max 1"; the patch uses the same virtual MIDI ports.
  - M4L device: `FC200 Mira.amxd` (repo root), a GUI for the script; to be refactored later
- Protocol: `protocol/presets.md` v0.2.0. Preset files and core API are implemented; the remote interface for a frontend is a **draft** (not implemented, needs approval). Change the spec first, then the code.
- Unit tests: `python3.11 -m unittest discover -s tests` (Live-free modules only)
- Type check: `mypy` (config in `mypy.ini`: Python 3.11 rules, skips vendored `xmltodict` and `MiraGUI`; mypy is installed system-wide, not in a venv)
- Live listeners: always add them through a `Listeners` registry (`src/listeners.py`): `listeners.add(subject, "<prop>", callback)`. FC200 keeps `_listeners` (added by `_setup`, removed on config reload and unload) and `_script_listeners` (the Link-toggle reload trigger, removed on unload). Callbacks are wrapped so exceptions are logged with a traceback.
- Live types: partial `.pyi` stubs for `Live` and `_Framework` in `stubs/` (mypy-only). Import Live types under `if TYPE_CHECKING:` with `from __future__ import annotations`, so nothing type-only is imported at runtime. Add a stub member when the script starts using one.
- Integration tests: none yet

### What this does
Roland FC200 floor pedal → MIDI SysEx → `src/FC200.py` (a `ControlSurface`) drives an audio effect rack (found by its device name, "FC200 Pedalboard", on any track) to emulate a pedalboard, plus transport/session control. `src/roland_exclusive.py` (no Live imports) holds the Roland Exclusive (DT1) format, the FC-200 address map and the bank display segment encoding; `src/hardware.py` drives the LEDs, bank display and mode. Names follow the FC-200 manual (pp. 39-44, `~/Documents/02 DEV - Max/FC200 Programming/FC-200 manual.pdf`).

### Pages (`src/pages.py`)
`FC200.handle_sysex` parses the message and hands it to the active `Mode`. The pages are `TransportPage` (0: transport, scenes, presets, ForScore), `LoopsPage` (1: loop on/off) and `FavoritesPage` (2: one favorite parameter per loop). `ParameterControl` takes over page 2 to edit one loop's macros and chains. Shared behaviour lives in `Page.handle`: bank pedals change the page, EXP sets the volume, CTL taps the tempo, FOOT SW/EXP 1 drives freeze (on page 2 only while no favorite is picked). Pages override the hooks they need. Each mode owns its state and cleans up in `on_exit()`; each page keeps its own LED state (`page.leds`, shown by `set_led` only while active). Pages have no runtime Live imports and are tested with a fake surface (`tests/test_pages.py`).

### Preset system (shadow JSON + dummy clip)
A dummy audio clip on the guitar track's clip slots doubles as a preset slot — its name is the preset name:
- `src/presets.py` (no runtime Live imports, tested with fake boards):
  - `Preset` (dataclass): board device index → `{parameters: [8 floats], chain: <selected chain name>}`; `Preset.read(board, indices)`, `preset.apply(board)`, `to_json`/`from_json`.
  - `PresetStore(folder)`: `exists`/`save`/`load` for `<PRESET_FOLDER>/_json/<clip name>.json`, and `write_alc` for the matching `.alc` clip (from `template.alc.xml`, patched via `xmltodict`) so the dummy clip is importable from Ableton's browser.
  - `PresetManager`: the store/recall flow for every consumer, with no hardware knowledge. It reports through `PresetEvents` subscribers. FC200 creates it (when a pedalboard is found), forwards `store(scene_index)`/`cancel()`/`disconnect()`, and subscribes `PresetFeedback` (`src/preset_feedback.py`: LED blink/flash on the store pedal and status-bar messages). A future frontend adapter subscribes the same way.
- **Store** (`PresetManager.store`): `Preset.read` from the board, then `PresetStore.save` (JSON + `.alc`). If a preset with that name already exists, it emits `overwrite_pending` and waits for a second store of the same name or `cancel()`.
- **Recall**: the manager listens to the track's `playing_slot_index` — when a clip is launched, `load` looks up `<clip name>.json` and `apply`s it to the board on the next tick. No-ops if no shadow file matches.
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
