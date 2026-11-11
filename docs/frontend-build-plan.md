# FC200 frontend build plan

Work packages (WPs) for building `docs/frontend-architecture.md`. Each WP is a
self-contained brief for one subagent. **Read the architecture doc first; it wins
over this file if they disagree.**

## Order and dependencies

```
WP0 spike ──────────────────────────────┐ (independent, needs the user)
WP1 spec ──► user approval ──┬─► WP2 shared protocol module
                             │        ├─► WP3 script gateway ─┐
                             │        └─► WP4 hub + mock ─────┼─► WP6 Mira removal
                             └──────────► WP5 web app ────────┘   (after user test)
```

- WP0 and WP1 can run in parallel.
- After WP2, **WP3, WP4 and WP5 run in parallel** in separate worktrees
  (`isolation: "worktree"`). WP5 develops against WP4's mock, or against the
  fixture in WP1 until the mock exists.
- WP6 only starts after the user has tested WP3–WP5 on hardware.

## Rules for every agent

- Load the `ableton-dev` skill for anything touching the Remote Script or Live.
- **Protocol first.** `protocol/frontend.md` is the contract. If a WP needs a change
  to it, stop and report back; don't edit the spec silently.
- Remote Script code (`src/`): Python 3.11, stdlib only, no runtime Live imports in
  logic modules (types under `if TYPE_CHECKING:`), listeners only through the
  `Listeners` registry, add stub members in `stubs/` when using new Live APIs.
  `src/FC200.py` uses **CRLF** line endings; keep them.
- Use FC-200 manual terminology (see the repo `CLAUDE.md`).
- Verify before reporting:
  `python3.11 -m unittest discover -s tests` and `mypy` for script code. For Live
  wiring, run the ableton-dev `reload-remote-scripts.sh` and check Log.txt (it lags
  about 1 s). Only the user can press pedals; say which verification level you
  reached.
- Don't commit. Leave changes in the worktree; the user reviews each WP in revdiff.
- Report back: what was built, files touched, verification output, deviations from
  this brief, and open questions.

---

## WP0: Network MIDI watchdog spike

**Goal:** prove or disprove that the Mac can restore the RTP-MIDI session to
ForScore automatically after the iPhone hotspot drops and comes back.

- Write a throwaway script in `apps/hub/spikes/netmidi_watchdog.py` using PyObjC
  (`pyobjc-framework-CoreMIDI`, added with `uv add` in `apps/hub`).
- It reads `MIDINetworkSession.defaultSession()`, logs its connections and hosts,
  browses Bonjour for `_apple-midi._udp`, and re-adds the ForScore host connection
  when it reappears.
- **Needs the user** to toggle the hotspot and watch ForScore. Prepare a
  step-by-step test script for them; don't claim success without their result.
- **Deliverable:** the spike, plus a short findings note appended to section 6 of
  the architecture doc (works / partly / no, and what ForScore needs).

## WP1: Protocol spec

**Goal:** write `protocol/frontend.md` v0.1.0 from section 9 of the architecture.

- Cover both transports (TCP JSON lines script↔hub, WebSocket hub↔clients) and the
  message envelope.
- Define the state tree per module (`page`/`mode`, `scenes`, `loops`, `edit`,
  `presets`, `tempo`, `hub`). Give each field a type, its meaning and the source in
  the script.
- Specify the patch format: dotted paths; a list replaced as a whole when its
  length changes; `null` deletes.
- Specify the methods with params, result and errors. Fold in the presets methods
  from `protocol/presets.md` §3 and mark that section superseded.
- Specify the versioning rules and the reconnect behaviour.
- Fix the ports: 20030 (script) and 20031 (hub).
- Add a JSON fixture `protocol/fixtures/snapshot.json` for the mock and tests.
- To get the field list right, read `src/pages.py`, `src/FC200.py`, `src/presets.py`
  and `src/MiraGUI.py`, the current UI to replace.
- **Gate:** the user approves the spec in revdiff before WP2–WP5 start.

## WP2: Shared protocol module

**Goal:** a stdlib-only module that the script and the hub both import.

- Create `src/ui_protocol.py` with the message encode/decode (JSON lines), the
  `StateModel` (`set(path, value)`, dirty tracking, `snapshot()`, `flush() -> patch
  | None`) and `apply_patch(state, patch)`.
- The hub reaches it through a symlink
  `apps/hub/fc200_hub/ui_protocol.py -> ../../../src/ui_protocol.py`.
- Tests go in `tests/test_ui_protocol.py`: coalescing (many sets in one flush),
  an unchanged value is not dirty, list replacement, and round-tripping a snapshot
  plus patches with `apply_patch` equals the model.
- Verify with unittest and mypy.

## WP3: Script gateway (producer)

**Goal:** the Remote Script serves the state and executes commands.

- `src/ui_gateway.py` is a non-blocking TCP server on 127.0.0.1:20030 with no
  threads. FC200 polls it from `update_display` (add that override). It accepts new
  clients, reads lines and dispatches methods, flushes the `StateModel` once per
  tick and sends the patch to all clients. A new client gets a snapshot first.
- Close the socket in `disconnect()`, so a reload doesn't leave the port bound
  (use `SO_REUSEADDR`).
- `src/ui_bindings.py` (Live-free, tested with fakes like `tests/test_pages.py`)
  maps the script state into the model:
  - It has hooks the pages and modes call: page change, LED and loop state, the
    selected parameter-control loop.
  - Scene listeners cover the selected and fired scene and the names and colors in
    the window.
  - Parameter listeners cover the favourites and the edit macros. Send `value`
    (normalised) and `display` (`str_for_value`).
  - A `PresetEvents` subscriber mirrors preset state.
- Commands call the same code paths as the pedal (`Page`/`Mode` methods,
  `PresetManager`), never a parallel implementation.
- Unknown methods return an error, and an exception in a handler is logged and
  returned as an error. Neither may crash the script.
- Leave `MiraGUI` in place and working (WP6 removes it).
- Verify with unit tests for the bindings and the dispatch, then mypy, then a Live
  reload. Then run `nc 127.0.0.1 20030` and check the snapshot, the patches while
  the user operates the pedal (or the virtual pedal), and a `param.set` sent by
  hand. Reload twice to confirm the port is released.

## WP4: Hub + mock + launchd

**Goal:** `apps/hub`, a Python relay between the script and the web clients.

- A `uv` project on Python 3.14: `apps/hub/pyproject.toml` with `aiohttp` and
  `zeroconf`, plus `.python-version` and `uv.lock`. Entry point
  `uv run python -m fc200_hub [--mock] [--port 20031]`. The symlinked
  `ui_protocol.py` must stay 3.11-compatible; don't "modernise" it.
- **Live link:** a TCP client to 127.0.0.1:20030 with reconnect and backoff. It
  caches the snapshot and applies patches with `ui_protocol.apply_patch`. It sets
  `hub.live_connected` and pushes that to clients.
- **WebSocket** `/ws`:
  - On connect it sends the cached snapshot plus `hub.status`.
  - It fans patches out to every client.
  - It forwards client requests to the script, rewriting the ids so replies route
    back to the right client.
  - Requests time out after 2 s with an error.
- **Static:** serves `apps/web/dist` at `/`.
- **mDNS:** advertises `fc200.local` / `_http._tcp` via `zeroconf`.
- **Mock (`--mock`):** loads `protocol/fixtures/snapshot.json`, emits plausible
  patches (scene changes, a dial sweep), and answers every method so the web app
  can be built without Live.
- **launchd:** add `apps/hub/launchd/nl.fc200.hub.plist` (KeepAlive, logs to
  `~/Library/Logs/fc200-hub.log`) plus an `install.sh`. Don't load it into launchd
  yourself; the user does that.
- Tests in `apps/hub/tests` (pytest + aiohttp test client) cover snapshot on
  connect, patch fan-out, request routing and timeouts, and a Live-link drop
  setting `live_connected` false and then recovering.
- Verify with pytest. Then run the hub in mock mode and connect a WebSocket client
  (for example `python -m aiohttp` or `websocat`).

## WP5: Web app

**Goal:** `apps/web`, a TypeScript + Svelte + Vite PWA.

- A store holds the state, applies patches and reconnects with backoff. It shows an
  offline banner while the hub or Live is disconnected.
- The views follow `page`/`mode`, with a pin toggle:
  - **Scenes:** prev3..next3, the current scene large, the fired scene marked, and
    scene colors.
  - **Loops:** an on/off grid with the active chain name.
  - **Favourites:** 10 dials with name and display value.
  - **Loop edit:** 8 macro dials and a chain picker.
- Dials send `param.set` while dragging, throttled to about 30 Hz. They show the
  server's value, not the optimistic local one, once the patch arrives.
- Presets: the store and recall actions, plus a visible overwrite-pending state
  with confirm and cancel.
- PWA: a manifest (standalone, dark theme), a service worker for the app shell
  only, the Wake Lock API and touch-first sizing. Layouts for iPhone portrait and
  iPad landscape.
- Dev: `npm run dev` proxies `/ws` to the hub on :20031; `npm run build` outputs to
  `dist/`, which the hub serves. Pin exact dependency versions.
- Tests: Vitest for the patch store and the throttling.
- Verify with `npm test` and `npm run build`. Then run against the mock hub and take
  screenshots at iPhone and iPad sizes. Device testing is done by the user.

## WP6: Mira removal (after the user's hardware test)

- Delete `src/MiraGUI.py`, its use in `FC200.py`, the Mira-only parts of
  `OSCremote` and `FC200 Mira.amxd`. Remove the `MiraGUI` exclusion from `mypy.ini`.
- Update the repo `CLAUDE.md` (the components, the OSC side-channel section and the
  new apps) and `TODO.md`.
- Verify with unittest, mypy, a Live reload and a clean Log.txt.
