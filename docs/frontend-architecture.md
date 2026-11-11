# FC200 frontend architecture (draft)

> Status: **proposal for review**. Nothing here is implemented. Annotate freely.

## 1. Goals

1. Show the live state on a phone, tablet or future hardware display without the
   MacBook screen: the current, previous and next scenes, the fired scene, the
   active page and mode, presets (including a pending overwrite), favourite and
   macro parameter values, and the selected chains.
2. Allow light editing from the display: turning a dial, picking a chain, and
   storing or recalling a preset.
3. Be reliable on stage. Live restarting, Wi‑Fi dropping or a display going to
   sleep must recover without anyone touching the Mac.
4. Be pleasant to develop: text sources, hot reload, unit tests, and a mock so the
   UI can be built without Live running.
5. Replace `MiraGUI.py` and `FC200 Mira.amxd`.

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

## 3. Options compared

| Criterion            | A: M4L + Node     | B: Max app        | C: Node process   |
|----------------------|-------------------|-------------------|-------------------|
| Starts with set      | yes               | no (launchd)      | no (launchd)      |
| Survives Live crash  | no                | yes               | yes               |
| LOM access           | yes (`live.*`)    | no                | no                |
| Live CPU impact      | inside Live       | none              | none              |
| Dev experience       | poor (Max+freeze) | medium (Max)      | good (npm, tests) |
| Testable without Live | partly           | partly            | fully (mock)      |
| Moving parts         | amxd + node       | Max runtime       | one node process  |

- **A** buys LOM access, but section 2 makes that unnecessary. Node for Max inside
  Live also dies or restarts with the device and the set, and it is the setup you
  are trying to leave.
- **B** is only worth it if Max-specific parts must live there. The one candidate is
  the existing standalone OSC→MIDI patch for ForScore. Node can send to the IAC bus
  directly (see section 7), so that is not a strong reason either.
- **C** is a plain Node (TypeScript) process run by a **launchd LaunchAgent** with
  `KeepAlive`. It is always running and idles while Live is closed. That removes
  the "I have to start it separately" con: you never start it at all.

**Recommendation: C**, with an optional later step that folds the ForScore
OSC→MIDI patch into it.

## 4. Proposed architecture

```
┌──────────────── MacBook ─────────────────────────────────────────┐
│                                                                  │
│  Ableton Live                                                    │
│  └─ FC200 Remote Script (Python)                                 │
│       ├─ pages / PresetManager / hardware   (existing)           │
│       └─ ui/  StateModel + Gateway  (new, Live-free core)        │
│             │  TCP 127.0.0.1:20030, JSON lines                   │
│             ▼  snapshot + patches  ▲ commands                    │
│  fc200-hub (Node/TS, launchd)                                    │
│       ├─ Live link: reconnecting TCP client, caches last state   │
│       ├─ WebSocket server  :20031  /ws                           │
│       ├─ static PWA         :20031  /                            │
│       └─ (later) ForScore MIDI out → IAC  (replaces Max patch)   │
└──────────────────────────────│───────────────────────────────────┘
                               │ Wi‑Fi / LAN (WebSocket)
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
  accepts one or a few clients. On connect it sends the full snapshot. It reads
  command lines and dispatches them to the script.
- Listeners are registered through the existing `Listeners` registry. They write
  into `StateModel`, never to the socket.
- `PresetManager` gets a `PresetEvents` subscriber that mirrors its state into the
  model. That subscriber is the "frontend adapter" the presets spec anticipates.
- `MiraGUI.py`, the `OSCremote` Mira bits and `FC200 Mira.amxd` are removed once the
  new UI covers the same ground.

**Why the script is the server and not a client.** Live can restart at any time.
Making the long-lived hub reconnect is simpler than putting retry logic inside the
script. It also means there is nothing to configure in Live.

### 4.2 Hub (fc200-hub)

- It is a dumb relay with a cache. It holds the latest snapshot, applies patches,
  fans them out to all WebSocket clients, and forwards commands from clients to the
  script.
- It adds a `live.connected` flag, so displays can show "Live offline" instead of
  frozen data.
- It serves the built PWA and binds to `0.0.0.0` for the LAN. Clients find it via
  Bonjour/mDNS (`fc200.local`), so no IPs are needed.
- `npm run mock` replaces the Live link with a scripted fake state, which lets you
  build the UI on the couch.
- It contains no FC200 business logic. If something needs a decision, it belongs in
  the script.

### 4.3 Frontend

- It is a PWA (Svelte or Preact + Vite), installed via "Add to Home Screen". It runs
  in standalone mode with no Safari UI, keeps the screen awake via the Wake Lock API,
  and reconnects with backoff.
- Its views map onto the pedal pages: **Scenes** (prev3..next3 + fired), **Loops**
  (on/off grid), **Favourites** (10 dials) and **Loop edit** (8 macros + chain
  picker). By default it follows the pedal's active page. A "pin" lock keeps a view
  fixed instead.
- The layout is responsive: the iPhone gets a single condensed view, and the iPad
  gets a grid.

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
4. **Dedicated hardware display** (ESP32 + TFT/e-ink). It speaks the same
   WebSocket protocol, which is why the protocol must not assume a browser.

None of these needs architecture changes. They are all just clients.

## 6. Protocol sketch

The specification goes in `protocol/frontend.md` (new). It reuses the conventions
from `presets.md` §3, and it **supersedes the presets remote-interface draft** by
folding it in.

- **Script ↔ hub** (TCP JSON lines):
  - `{"event":"state.snapshot","data":{...}}` on connect.
  - `{"event":"state.patch","data":{"<path>":value,...}}` once per tick at most.
  - Requests use `{"id","method","params"}`, for example `param.set`,
    `chain.select`, `preset.store`, `preset.recall` and `page.set`.
- **Hub ↔ clients** (WebSocket): the same messages, plus `hub.status`
  (`live.connected`). The hub passes messages through unchanged.
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

## 7. ForScore MIDI (optional, later)

Today the path is `OSCremote` → standalone Max patch → IAC → a Live MIDI track with
`page_turner` → Network MIDI → ForScore. The hub could receive the same OSC (or a
`forscore.*` command over the existing TCP link) and write to IAC itself using
`@julusian/midi`. That would remove the separate Max app. This still respects the
rule "don't send MIDI from the Remote Script". It is out of scope for the first
version; it is mentioned only so the hub is designed to host it.

## 8. Phases

1. **Spec**: write `protocol/frontend.md`, then get your approval.
   Verify: the spec has been reviewed.
2. **Producer core**: build `ui_state.py` plus its unit tests (snapshot, dirty
   paths, coalescing). Verify: unittest and mypy pass.
3. **Gateway in Live**: build `ui_gateway.py` and wire the listeners.
   Verify: `nc 127.0.0.1 20030` shows the snapshot and patches, and Log.txt is
   clean.
4. **Hub + mock**: build the Node relay, the mock mode and the launchd plist.
   Verify: wscat sees the state, and the hub survives a Live restart.
5. **PWA**: build the Scenes view first, then Favourites, Loop edit and Loops.
   Verify: it works on the iPhone over Wi‑Fi in Guided Access.
6. **Removal**: delete MiraGUI, the Mira amxd and its OSC code.
7. (Optional) ForScore MIDI moves into the hub.

## 9. Open questions

1. Hub language: TypeScript/Node, which has PWA tooling and `@julusian/midi`, or
   Python (`websockets`), which is the same language as the script?
2. Should the frontend be able to *change* things in v1, or start read-only?
3. Repo layout: should the hub and PWA be in this repo (`apps/hub`, `apps/web`) or in
   a separate one? This repo makes protocol changes atomic.
4. Do you want access from outside the LAN (for example a phone on mobile data)?
   That's assumed **no**, and there's no auth on the LAN.
5. Ports 20030/20031: is that OK, alongside 20022 (OSCremote)?
6. Is the iPad, the iPhone or the hardware display the primary target for v1? That
   decides the first layout.
