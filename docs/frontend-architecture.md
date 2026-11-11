# FC200 frontend architecture (draft)

> Status: **proposal for review**. Nothing here is implemented. Annotate freely.

## 1. Goals

1. Show the live state on a phone, tablet or future hardware display without the
   MacBook screen: the current, previous and next scenes, the fired scene, the
   active page and mode, presets (including a pending overwrite), favourite and
   macro parameter values, and the selected chains.
2. Allow editing from the display from v1 on: turning a dial, picking a chain, and
   storing or recalling a preset. The protocol is bidirectional from the start.
3. Be expandable. The frontend starts as a small extra display but may eventually
   replace the main Ableton view completely, with all control on the FC200 or the
   frontend. The state model and commands are therefore organised in independent
   modules (`scenes`, `loops`, `presets`, ...) so new ones can be added without
   breaking clients.
4. Be reliable on stage. Live restarting, the network dropping or a display going to
   sleep must recover without anyone touching the Mac (see section 6).
5. Be pleasant to develop: text sources, hot reload, unit tests, and a mock so the
   UI can be built without Live running.
6. Replace `MiraGUI.py` and `FC200 Mira.amxd`.

Non-goals: audio, and replacing the pedal as the primary controller.

## 2. The real question: who observes Live?

With Mira, the script only hands out LOM *paths*, and `[live.path]` and
`[live.observer]` in M4L do the observing. That is why the M4L option looks
attractive: it is the only place outside Python that can read the LOM.

Two facts change that trade-off:

- **The state the UI needs is small and bounded.** It is roughly 7 scenes, up to
  10 favourite parameters, 8 macros plus a chain list for one loop, and the
  preset status. That comes to a few dozen listeners, not "the whole set". The
  script already owns most of this state (`_selected_scene_index`,
  `_fired_scene`, pages, `PresetManager`).
- **Python listener cost is not the bottleneck; un-throttled sending is.** The
  expensive case is EXP sweeping a parameter, which fires a callback on every
  change. If changes are coalesced into a dirty set and flushed once per
  `update_display` tick (about 100 ms, or every second tick), the load on Live's
  main thread stays negligible.

So the proposal is that **the Remote Script becomes the single source of
truth** and pushes a compact state model. Everything outside Live only relays and
renders it, and no other component needs LOM access. This matches the ableton-dev
"gateway" pattern and removes the dependency on M4L.

As the frontend grows towards replacing the Ableton view (goal 3), the state grows
too. Each module only registers its listeners while a client subscribes to it, so
the cost stays proportional to what is actually on screen.

## 3. Options compared

| Criterion             | A: M4L + Node     | B: Max app        | C: own process    |
|-----------------------|-------------------|-------------------|-------------------|
| Starts with set       | yes               | no (launchd)      | no (launchd)      |
| Survives Live crash   | no                | yes               | yes               |
| LOM access            | yes (`live.*`)    | no                | no                |
| Live CPU impact       | inside Live       | none              | none              |
| Dev experience        | poor (Max+freeze) | medium (Max)      | good (pip, tests) |
| Testable without Live | partly            | partly            | fully (mock)      |
| Moving parts          | amxd + node       | Max runtime       | one process       |

- **A** buys LOM access, but section 2 makes that unnecessary. Node for Max inside
  Live also dies or restarts with the device and the set, and it is the setup you
  are trying to leave.
- **B** is only worth it if Max-specific parts must live there. The one candidate is
  the existing standalone OSC→MIDI patch for ForScore, and Python can send to the IAC
  bus directly (see section 8).
- **C** is a plain **Python** process run by a **launchd LaunchAgent** with
  `KeepAlive`. It is always running and idles while Live is closed. That removes
  the "I have to start it separately" con: you never start it at all.

**Decision: C, in Python.** Running the same hub inside Max for shows and outside it
for development was considered and rejected: it doubles the environments to test,
and launchd already gives the "always there" behaviour without Max.

## 4. Proposed architecture

```
┌──────────────── MacBook ─────────────────────────────────────────┐
│                                                                  │
│  Ableton Live                                                    │
│  └─ FC200 Remote Script (Python 3.11, in Live)                   │
│       ├─ pages / PresetManager / hardware   (existing)           │
│       └─ ui_state + ui_gateway  (new, Live-free core)            │
│             │  TCP 127.0.0.1:20030, JSON lines                   │
│             ▼  snapshot + patches  ▲ commands                    │
│  fc200-hub (Python, asyncio + aiohttp, launchd)                  │
│       ├─ Live link: reconnecting TCP client, caches last state   │
│       ├─ WebSocket server  :20031  /ws                           │
│       ├─ static web app    :20031  /                             │
│       └─ (later) ForScore MIDI out → IAC  (replaces Max patch)   │
└──────────────────────────────│───────────────────────────────────┘
                               │ network (see section 6)
          ┌────────────────────┼──────────────────────┐
          ▼                    ▼                      ▼
     iPad (PWA)          iPhone (PWA)        ESP32 + display (future)
```

### 4.1 Remote Script side (producer)

- New Live-free module `src/ui_state.py` with a `StateModel` (a nested dict with a
  `set(path, value)` that records dirty paths) and `flush() -> patch | None`. It is
  unit-tested like `pages.py`.
- New `src/ui_gateway.py` with a non-blocking TCP server socket that is polled from
  `update_display` (no threads, so all LOM access stays on Live's main thread). It
  accepts a few clients. On connect it sends the full snapshot. It reads command
  lines and dispatches them to the script.
- Listeners are registered through the existing `Listeners` registry. They write
  into `StateModel`, never to the socket.
- Commands go through the same code paths as the pedal (`Mode`/`Page` methods,
  `PresetManager`), so the pedal and the frontend can never disagree on behaviour.
- `PresetManager` gets a `PresetEvents` subscriber that mirrors its state into the
  model. That subscriber is the "frontend adapter" the presets spec anticipates.
- `MiraGUI.py`, the `OSCremote` Mira bits and `FC200 Mira.amxd` are removed once the
  new UI covers the same ground.

**Why the script is the server and not a client.** Live can restart at any time.
Making the long-lived hub reconnect is simpler than putting retry logic inside the
script. It also means there is nothing to configure in Live.

### 4.2 Hub (`apps/hub`)

- It is written in Python 3.11+ with its own venv (pip is available here, unlike
  in Live), using `aiohttp` for HTTP and WebSocket on one port.
- It shares the protocol code with the script: patch application and the message
  types live in a small Live-free package that both import.
- It is a dumb relay with a cache. It holds the latest snapshot, applies patches,
  fans them out to all WebSocket clients, and forwards commands from clients to the
  script.
- It adds a `hub.live_connected` flag, so displays can show "Live offline" instead
  of frozen data.
- It serves the built web app and binds to `0.0.0.0`. Clients find it via
  Bonjour/mDNS (`fc200.local`), so no IPs are needed.
- `python -m hub --mock` replaces the Live link with a scripted fake state, which
  lets you build the UI without Live.
- It contains no FC200 business logic. If something needs a decision, it belongs in
  the script.

### 4.3 Frontend (`apps/web`)

- It is a PWA (TypeScript + Svelte + Vite), installed via "Add to Home Screen". It runs
  in standalone mode with no Safari UI, keeps the screen awake via the Wake Lock API,
  and reconnects with backoff.
- Its views map onto the pedal pages: **Scenes** (prev3..next3 + fired), **Loops**
  (on/off grid), **Favourites** (10 dials) and **Loop edit** (8 macros + chain
  picker). By default it follows the pedal's active page. A "pin" lock keeps a view
  fixed instead.
- The layout is responsive. The iPhone and the iPad are both primary targets for v1:
  the iPhone gets a single condensed view and the iPad a grid.

### 4.4 Repo layout (monorepo)

```
src/            Remote Script (existing, symlinked into Live)
protocol/       presets.md, frontend.md (new)
apps/hub/       Python hub + mock + launchd plist
apps/web/       PWA
tests/          script tests (existing); hub tests live in apps/hub/tests
```

## 5. iPad and ForScore problem

The Safari Slide Over gestures fight with ForScore's edge gestures. The options,
from least to most effort:

1. **Separate iPhone as the display**, a PWA on a mic-stand mount with Guided
   Access. It doesn't conflict with ForScore at all and is probably the most robust
   on stage.
2. **iPadOS windowed multitasking** (iPadOS 26 windowing / Stage Manager). The PWA
   is its own app window next to ForScore, with no slide gesture involved. Test this
   with your exact iPad model and ForScore's full-screen behaviour.
3. **A thin status strip only.** A tiny window showing just the scene name and
   preset, so ForScore keeps almost the whole screen.
4. **Picture-in-Picture overlay.** A floating, read-only window over ForScore (see
   section 7).
5. **Dedicated hardware display** (ESP32 + TFT/e-ink). It speaks the same
   WebSocket protocol, which is why the protocol must not assume a browser.

None of these needs architecture changes. They are all just clients.

## 6. Network on stage

The current setup, an iPhone hotspot that the Mac and the iPad join, collapses when
the iPhone moves too far from the Mac. ForScore's Network MIDI depends on the same
network, so the problem is not specific to the frontend.

The iPhone hotspot stays; a separate router is not an option. Rejoining the hotspot
is not the painful part. **Restoring everything afterwards is**, especially the
Network MIDI session to ForScore. So the goal is: after the network comes back,
everything recovers without manual steps.

Proposal:

1. **Self-healing clients.** The hub and the clients reconnect with backoff and find
   the hub by name (`fc200.local`), not IP, because the hotspot may hand out new
   addresses. A reconnecting client gets a full snapshot. A dropout then shows
   "offline" for a moment and recovers on its own.
2. **Network MIDI watchdog in the hub.** macOS keeps the RTP-MIDI session to
   ForScore in CoreMIDI's `MIDINetworkSession`, the same thing Audio MIDI Setup
   edits by hand. The hub can drive it from Python via PyObjC
   (`pyobjc-framework-CoreMIDI`): watch for the iPad's Bonjour service to reappear
   and re-add the connection. That turns the manual "fix Network MIDI" step into
   nothing. **This needs a spike** to confirm that ForScore accepts a re-initiated
   session without user action on the iPad.
3. **A cable for ForScore MIDI** as an alternative to the watchdog. An iPad on USB
   to the Mac shows up in Audio MIDI Setup as a MIDI device (IDAM) without any
   network, so page turns no longer depend on Wi‑Fi at all. This only works if the
   iPad is within cable reach of the Mac.
4. **Peer-to-peer (AWDL / MultipeerConnectivity)**, the AirDrop/Handoff layer, is
   only reachable from native apps, not from a PWA. Keep it as a future option if a
   native shell is ever built (section 7). The protocol stays transport-agnostic so
   that remains possible. AWDL has roughly Wi‑Fi range, so moving too far still
   drops the link. Its advantage is that it reconnects automatically with no hotspot
   in between.

## 7. Native shell (future, optional)

A small Swift iOS app would unlock what a PWA can't:

- **A custom Picture-in-Picture** (`AVPictureInPictureController` with custom
  content) that floats over ForScore. It can be shown on demand, for example when
  parameter mode starts. It is read-only.
- **Peer-to-peer networking** over AWDL without any router.
- **Live Activities** for status on the iPhone lock screen and Dynamic Island.

It would render the same web UI in a WKWebView and use the same protocol, so this is
an add-on, not a rewrite. Out of scope for v1.

## 8. ForScore MIDI (optional, later)

Today the path is `OSCremote` → standalone Max patch → IAC → a Live MIDI track with
`page_turner` → Network MIDI → ForScore. The hub could receive the same OSC (or a
`forscore.*` command over the existing TCP link) and write to IAC itself using
`mido` + `python-rtmidi`. That would remove the separate Max app. This still respects
the rule "don't send MIDI from the Remote Script". It is out of scope for the first
version; it is mentioned only so the hub is designed to host it.

## 9. Protocol sketch

The specification goes in `protocol/frontend.md` (new). It reuses the conventions
from `presets.md` §3, and it **supersedes the presets remote-interface draft** by
folding it in.

- **Script ↔ hub** (TCP JSON lines):
  - `{"event":"state.snapshot","data":{...}}` on connect.
  - `{"event":"state.patch","data":{"<path>":value,...}}` once per tick at most.
  - Requests use `{"id","method","params"}`, namespaced per module, for example
    `param.set`, `chain.select`, `preset.store`, `preset.recall` and `page.set`.
- **Hub ↔ clients** (WebSocket): the same messages, plus `hub.status`
  (`live_connected`). The hub passes messages through unchanged.
- **Versioning:** the snapshot carries the protocol version. Adding a module or a
  field is a minor bump, and clients ignore modules and fields they don't know.
- **State shape** (first pass):

  ```json
  {
    "version": "0.1.0",
    "page": 0, "mode": "transport",
    "scenes": {"selected": 12, "fired": null,
               "window": [{"index": 9, "name": "Intro", "color": 16711680}, "..."]},
    "loops": [{"index": 0, "name": "Drive", "on": true, "chain": "TS808",
               "chains": ["TS808", "Klon"],
               "favorite": {"name": "Gain", "value": 0.42, "display": "4.2"}}],
    "edit": {"loop": 2, "macros": [{"name": "Gain", "value": 0.4, "display": "4.0"}]},
    "presets": {"pending_overwrite": null, "last": "Song A"},
    "tempo": 120.0
  }
  ```

  Values carry both the normalised value (for dials) and Live's display string
  (`str_for_value`), so clients never need parameter ranges.

- Patches with path keys (`"loops.2.favorite.value"`) are simple to apply in JS,
  in Python and on an ESP32.

## 10. Phases

1. **Spec**: write `protocol/frontend.md`, then get your approval.
   Verify: the spec has been reviewed.
2. **Producer core**: build `ui_state.py` plus its unit tests (snapshot, dirty
   paths, coalescing). Verify: unittest and mypy pass.
3. **Gateway in Live**: build `ui_gateway.py`, wire the listeners and the commands.
   Verify: `nc 127.0.0.1 20030` shows the snapshot and patches, a command changes
   Live, and Log.txt is clean.
4. **Hub + mock**: build the Python relay, the mock mode and the launchd plist.
   Verify: a WebSocket client sees the state, and the hub survives a Live restart.
5. **PWA**: build the Scenes view first, then Favourites, Loop edit and Loops.
   Verify: it works on the iPhone and the iPad over the stage network.
6. **Removal**: delete MiraGUI, the Mira amxd and its OSC code.
7. (Optional) ForScore MIDI moves into the hub.
8. (Optional) Native shell (section 7).

## 11. Decisions

| Topic              | Decision                          |
|--------------------|-----------------------------------|
| Architecture       | C: own process via launchd        |
| Hub language       | Python                            |
| Editing in v1      | yes, bidirectional from the start |
| Repo               | monorepo (`apps/hub`, `apps/web`) |
| Access outside LAN | no, no auth for now               |
| Ports              | 20030 (script), 20031 (hub)       |
| v1 targets         | iPad and iPhone                   |
| Frontend stack     | TypeScript + Svelte + Vite        |
| Stage network      | iPhone hotspot, self-healing      |
| Native shell       | later, wraps the same web UI      |

Svelte works fine in a native shell: the build is plain static HTML/JS that a
WKWebView loads like any page.

## 12. Open questions

1. Network MIDI watchdog: should the spike from section 6 come before the frontend
   work, since it is the biggest pain on stage today?
