## Ableton
Uses the `ableton-dev` skill — load it for any Live/Max/Remote Script/extension work.
- Live versions pinned: Suite 12.4.16 for production (reselecting a control surface doesn't re-import the script: restart Live), Beta 12.4b16 for development (Tools → Reload MIDI Remote Scripts)
- Components:
  - MIDI Remote Script: `src/` (symlinked into Live User Library as `_FC200_SysEx_dev`; `_FC200_SysEx` points to the sibling `fc200-python-main` worktree, detached at a release tag)
  - Virtual pedal: `live/virtual-pedal/FC200_virtual-pedal.maxpat`, an air-gapped Max patch that emulates the FC-200 in Exclusive (SysEx) mode, for testing without the hardware. MIDI only (no OSC): in Live, select the Remote Script with MIDI in/out "from Max 1" / "to Max 1"; the patch uses the same virtual MIDI ports.
  - Frontend: `apps/hub` (Python relay) + `apps/web` (Svelte web app), protocol `protocol/frontend.md`. It replaced the Mira GUI (`MiraGUI.py`, `FC200 Mira.amxd`), removed in WP6
  - Test set: `live/fc200-python Project/`. `tools/`: standalone helpers (`backwards-compatible.py` downgrades an `.als` to an older Live version)
- Protocol: `protocol/presets.md` v0.2.0. Preset files and core API are implemented; the remote interface for a frontend is a **draft** (not implemented, needs approval). Change the spec first, then the code.
- Live sets (outside the repo, in `~/Documents/01 AUDIO - 05 Worship Multitracks/_eGit FC200 2026 =BASIC= Project/`), all with the "FC200 Pedalboard" rack on the eGit track:
  - `_eGit FC200 2026 Live.als`: production, opened in Suite.
  - `_eGit FC200 2026 Live dev.als`: development, usually opened in Beta (saving there makes it unreadable for Suite; accepted).
  - `_eGit FC200 2026 Live dev LIGHT.als`: the dev set with every third-party plugin on eGit replaced by stock devices (same rack/chain/device order and macro names, so the script's indices still hold); loads much faster. Some macros have no stock equivalent and do nothing, and values were estimated, so it sounds different: for testing the script, not for gigs.
- Release: `make release` on dev tags HEAD `vYYYY.MM.DD` (annotated, commits since the last release as message) and pushes the tag. Deploy: `make deploy [V=<tag>]` in `fc200-python-main` checks out the tag (default newest; an older one rolls back), updates the hub venv, builds the web app and runs `install.sh`. `main` isn't used by either. Restart Live Suite afterwards for Remote Script changes.
- Hub in production: a launchd agent (`apps/hub/launchd/`, installed by `install.sh`, port 200) that the Remote Script starts on load (`src/hub_service.py`), only when the agent runs from the script's own checkout. The hub exits 10 minutes after Live is gone (`--idle-exit 600`). `~/Applications/FC200 Hub.app` is a launcher window to start, stop and open it. Dev: `make dev` (hub on 20031 + Vite on 5173, against Live) or `make mock` (fake state, no Live); both without mDNS, so open `http://<Mac IP>:5173`. `make test` runs every check that works without Live.
- Unit tests: `python3.11 -m unittest discover -s tests` (Live-free modules only)
- Type check: `mypy` (config in `mypy.ini`: Python 3.11 rules, skips vendored `xmltodict`; mypy is installed system-wide, not in a venv)
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

### MIDI to ForScore (through the hub)
The ForScore pedals (page 0, 9/10) send a program change on channel 16 as a `midi.send` hub command (`FC200._midi_send`, `protocol/frontend.md` section 8); the hub (`apps/hub/fc200_hub/midi_out.py`) sends it to CoreMIDI:

```
FC200.py ─TCP 20030, midi.send─► hub ─CoreMIDI─► IAC "FC200 > Ableton" ─► MIDI track in Live
       ├─ M4L "page_turner" (MIDI middleware, e.g. makes automation possible)
       └─ output → Network MIDI ─► ForScore on iPad
```

Why not from the script: its own output (`_send_midi`) carries only the FC-200's SysEx. Looped back into Live through IAC and a MIDI track, the first channel message makes Live stop passing the script's SysEx until the script reloads. The hub stamps each packet with the host time: a packet stamped 0 jams Live's IAC track input until the port is toggled. Without a running hub the pedals send nothing.

## Dev servers
- When the user starts working on this project, start the dev servers yourself with the Bash tool's `run_in_background` (not in the user's terminal), so you can read their output: `make dev` when Live is running, otherwise `make mock`.
- First check that :5173 and :20031 are free (`lsof -nP -iTCP:5173 -iTCP:20031 -sTCP:LISTEN`); if something already listens, say so instead of starting a second copy.
- Give the user the phone URL: `http://<Mac IP>:5173` (`ipconfig getifaddr en0`).

## Review workflow (revdiff)
- After making changes, open them in revdiff for review.
- Annotations that are questions or remarks without a change request: answer them in the terminal, not in revdiff. Put the answers at the end of the turn, just before re-opening revdiff, so they aren't buried under later tool output.
- Annotations that suggest changes: commit the current state first, then address them, so each revision can be reviewed as its own diff.
