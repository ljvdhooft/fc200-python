# Frontend protocol

**Version 0.1.0**. Semver: minor for additions, major for breaking changes (0.x: minor may break).

| Version | Change                                                                  |
|---------|-------------------------------------------------------------------------|
| 0.1.0   | First version; folds in and supersedes `presets.md` §3                  |

| Part                  | Status                                     |
|-----------------------|--------------------------------------------|
| 1. Transports         | **Draft, not implemented.** Needs approval |
| 2. Messages           | Draft                                      |
| 3. State tree         | Draft                                      |
| 4. Patches            | Draft                                      |
| 5. Methods            | Draft                                      |
| 6. Versioning         | Draft                                      |
| 7. Reconnect          | Draft                                      |

The Remote Script is the single source of truth for the FC200 state. It pushes
the state to a **hub** (`apps/hub`), which relays it to **clients** (web app,
future hardware display). Clients send requests, which the hub relays back to the
script. Design background: `docs/frontend-architecture.md`.

## 1. Transports

| Link          | Transport                   | Address                              |
|---------------|-----------------------------|--------------------------------------|
| script - hub  | TCP, newline-delimited JSON | `127.0.0.1:20030` (script listens)   |
| hub - client  | WebSocket, one JSON per text frame | `ws://<host>:20031/ws` (hub listens) |

- The **script is the server**, so Live can restart without any client logic in the script. It accepts several connections (the hub, plus `nc` for debugging).
- JSON lines: UTF-8, one message per line, terminated by `\n`, no embedded newlines.
- The hub serves the web app on the same port (`http://<host>:20031/`).
- The hub passes script messages to clients **unchanged**, except for request ids (section 5) and the `hub` node (section 3).
- The protocol assumes nothing browser-specific, so an ESP32 can be a client.
- No authentication: LAN only.

## 2. Messages

Same conventions as `presets.md` §3 (ableton-dev conventions):

| Kind     | Shape                                                   | Direction                |
|----------|---------------------------------------------------------|--------------------------|
| Request  | `{"id", "method", "params"}`                            | client - hub - script    |
| Response | `{"id", "result"}` or `{"id", "error": {"code", "message"}}` | script - hub - client |
| Event    | `{"event", "data"}`                                     | pushed unsolicited       |

- `id` is a string or integer chosen by the requester, unique among its open requests. `params` may be omitted when a method takes none.
- Every request gets exactly one response.
- Unknown fields in any message are ignored.

### Events

| Event                | Data                          | From          | When                                             |
|----------------------|-------------------------------|---------------|--------------------------------------------------|
| `state.snapshot`     | the full state tree           | script, hub   | On connect, and on every reconnect               |
| `state.patch`        | `{"<path>": value, ...}`      | script, hub   | At most once per `update_display` tick, never empty |
| `hub.status`         | `{"live_connected": bool}`    | hub           | On client connect, and when the Live link changes |
| `preset.<event>`     | see below                     | script        | A `PresetEvents` call (transient, not in state)  |

Preset events carry the arguments of the matching `PresetEvents` method
(`presets.md` §2): `preset.overwrite_pending {"name"}`, `preset.overwrite_cancelled {"name"}`,
`preset.saved {"name"}`, `preset.save_failed {"name"}`, `preset.recalled {"name"}`,
`preset.template_clip_copied {"scene_index"}`, `preset.template_clip_missing {}`.
The durable part (`pending_overwrite`, `names`, `last`) is also in the state tree, so
a client that misses an event still converges.

## 3. State tree

The snapshot is a JSON object. Modules are top-level keys; a client ignores keys
it doesn't know. **Missing and `null` mean the same** ("none"): a producer may send
either in a snapshot, and a patch sets `null` by deleting the key (section 4).
`value` is always the **normalised** value (0..1, i.e. `(value - min) / (max - min)`
of the `DeviceParameter`) and `display` is Live's string for it
(`str_for_value(value)`), so clients never need parameter ranges.

### Root

| Field       | Type   | Meaning                          | Source                                  |
|-------------|--------|----------------------------------|-----------------------------------------|
| `version`   | string | Protocol version, `"0.1.0"`      | constant in the script                  |
| `page`      | int    | Active page, `MIN_PAGE..MAX_PAGE` (0 transport, 1 loops, 2 favorites) | `FC200._page` |
| `mode`      | string | `"transport"`, `"loops"`, `"favorites"` or `"parameter_control"` | class of `FC200._mode` (`TransportPage`, `LoopsPage`, `FavoritesPage`, `ParameterControl`) |
| `tempo`     | float  | Song tempo in BPM                | `Song.tempo` (listener)                 |

`mode` equals the page name except while `ParameterControl` is active (it sits on page 2).

### `transport`

| Field       | Type | Meaning                      | Source                                         |
|-------------|------|------------------------------|------------------------------------------------|
| `playing`   | bool | Song is playing (pedal 1 LED)| `Song.is_playing` (`_on_is_playing_changed`)   |
| `metronome` | bool | Metronome on (pedal 6 LED)   | `Song.metronome` (`_on_metronome_changed`)     |

### `scenes`

| Field      | Type        | Meaning                                                  | Source                                 |
|------------|-------------|----------------------------------------------------------|----------------------------------------|
| `count`    | int         | Number of scenes in the set                              | `len(FC200._all_scenes)`               |
| `selected` | int         | Index of the selected scene                              | `FC200._selected_scene_index` (`Song.view.selected_scene`) |
| `fired`    | object/null | Scene last fired from the pedal: `{index, name, color}`  | `FC200._fired_scene` (`TransportPage._fire_scene`) |
| `window`   | list        | Scenes `selected-3 .. selected+3`, clipped to existing scenes, in order | `Song.scenes` |

A `window` / `fired` entry: `index` (int), `name` (string, `Scene.name`), `color`
(int, `Scene.color`, `0xRRGGBB`). The window replaces `MiraGUI.scene_overview`
(`prev3..next3`, `cur`); the current scene is the entry whose `index` equals `selected`.

### `loops`

A list with one entry per `config.Settings.LOOP_MAPPING` item, in pedal order. A loop
is a rack on the pedalboard (`FC200._loop(index)`).

| Field      | Type        | Meaning                                                  | Source                                               |
|------------|-------------|----------------------------------------------------------|------------------------------------------------------|
| `index`    | int         | Board device index (the key used in preset files)        | `LOOP_MAPPING[n]`                                    |
| `pedal`    | int         | Number pedal 1..n that switches it (1-based)             | position in `LOOP_MAPPING` + 1                       |
| `name`     | string      | Loop name                                                | `RackDevice.name`                                    |
| `on`       | bool        | Loop is on                                               | `parameters[0].value != 0`                           |
| `chain`    | string      | Selected chain name                                      | `RackDevice.view.selected_chain.name`                |
| `chains`   | string[]    | All chain names, in order                                | `[c.name for c in RackDevice.chains]`                |
| `favorite` | object/null | The loop's favorite parameter (page 2); see below        | `parameters[FAVORITE_PARAMETERS[n]]`                 |

`favorite`:

| Field       | Type   | Meaning                                                      | Source                                      |
|-------------|--------|--------------------------------------------------------------|---------------------------------------------|
| `parameter` | int    | Parameter index within the loop                              | `FAVORITE_PARAMETERS[n]`                    |
| `name`      | string | Parameter name                                               | `DeviceParameter.name`                      |
| `value`     | float  | Normalised value                                             | `DeviceParameter.value`                     |
| `display`   | string | Live's display string                                        | `DeviceParameter.str_for_value`             |
| `picked`    | bool   | This favorite is the one the expression pedal controls       | `FavoritesPage.pedal` / `.parameter`        |

### `edit`

Present only while `mode` is `"parameter_control"`; otherwise missing/`null`.

| Field      | Type     | Meaning                                                     | Source                                   |
|------------|----------|-------------------------------------------------------------|------------------------------------------|
| `loop`     | int      | Board device index of the loop being edited (`loops[].index`)| `ParameterControl.device_index`          |
| `name`     | string   | Loop name                                                   | `ParameterControl.rack.name`             |
| `selected` | int/null | Position in `macros` the expression pedal controls          | `ParameterControl.selected` / `.parameter` |
| `macros`   | list     | The 8 macros of the loop, in parameter order                | `rack.parameters[1..8]`                  |

A macro: `parameter` (int, 1..8), `name`, `value`, `display` (as for `favorite`), and
`pedal` (int, 1-based number pedal that selects it: macros 1-4 map to pedals 6-9,
macros 5-8 to pedals 1-4, see `ParameterControl._select_macro`). The loop's chain is
in `loops[]` (`chain`, `chains`), not repeated here.

### `presets`

| Field               | Type        | Meaning                                              | Source                                           |
|---------------------|-------------|------------------------------------------------------|--------------------------------------------------|
| `names`             | string[]    | Stored preset names, sorted                          | `PresetManager.preset_names()`                   |
| `pending_overwrite` | string/null | Preset waiting for overwrite confirmation            | `PresetManager.pending_overwrite`                |
| `last`              | string/null | Name of the last preset saved or recalled            | `PresetEvents.saved` / `recalled` (subscriber)   |

Missing when the script found no pedalboard (`PresetManager` is None); so are
`loops` (empty list) and `edit`.

### `hub`

Added by the hub, never by the script.

| Field            | Type | Meaning                                  | Source              |
|------------------|------|------------------------------------------|---------------------|
| `live_connected` | bool | The hub has a live link to the script    | hub's TCP client    |

While `live_connected` is false the rest of the tree is the **last known** state and is stale.

## 4. Patches

`{"event": "state.patch", "data": {"<path>": value, ...}}`

- A **path** is dotted from the root. Object keys are used as-is; list elements by decimal index: `loops.2.favorite.value`, `scenes.window.3.name`, `edit.macros.0.display`. No key contains a dot.
- **Set:** the path's value becomes `value` (any JSON type). **Delete:** `null` removes the key (so "none" reads as missing; see section 3).
- A **list is replaced as a whole** when its length changes: the producer sends the full list at the list's path (`"scenes.window": [...]`, `"loops.2.chains": [...]`). Element paths are only used while the length is unchanged.
- To add an object (e.g. `edit` when entering `parameter_control`), the producer sends the full object at its path. A patch whose parent path doesn't exist is ignored by the consumer (log it); the next reconnect resyncs.
- A patch contains no path that is a prefix of another. Entries are applied in object order.
- The producer coalesces: many changes within one tick yield one patch; a value equal to the current one is not sent; no empty patch is sent. Rate: at most one patch per `update_display` tick (about 100 ms).
- `state.patch` is applied by the hub to its cache and forwarded unchanged.

## 5. Methods

Requests go client - hub - script. The hub replaces `id` with its own and routes the
response back with the client's original `id`. Methods are namespaced per module.
All run on Live's main thread, through the same code paths as the pedal. A method
changes state; the new state arrives as a patch (the result does not replace it).

| Method           | Params                                         | Result                          |
|------------------|------------------------------------------------|---------------------------------|
| `page.set`       | `{"page": int}`                                | `{"page": int}`                 |
| `loop.set`       | `{"loop": int, "on": bool}`                    | `{"on": bool}`                  |
| `chain.select`   | `{"loop": int, "chain": string}`               | `{"chain": string}`             |
| `param.set`      | `{"loop": int, "parameter": int, "value": float}` | `{"value": float, "display": string}` |
| `preset.list`    | none                                           | `{"names": [string]}`           |
| `preset.get`     | `{"name": string}`                             | the preset object (`presets.md` §1) |
| `preset.store`   | `{"scene_index": int}`                         | `{}`; outcome as `preset.*` event and `presets` state |
| `preset.cancel`  | none                                           | `{"cancelled": bool}`           |
| `preset.recall`  | `{"name": string}`                             | `{"found": bool}`               |

- `loop` is a board device index (`loops[].index`), not a position. `value` is normalised 0..1; the script clamps it.
- `page.set` calls `FC200._show_page`: it leaves `parameter_control` and drops a favorite or pending overwrite, like a bank pedal.
- `param.set` accepts `parameter` 1..8 (macros) and the loop's favorite parameter. It does **not** change what the expression pedal controls (`picked` / `selected`).
- `chain.select` matches the chain by name, like a preset recall. While the loop is being edited, the script keeps `ParameterControl`'s chain index in sync.
- `preset.store` and `preset.recall` behave exactly as `PresetManager.store` / `recall`; a second `preset.store` for the same name confirms an overwrite, `preset.cancel` drops it.
- `preset.state` from `presets.md` §3 is replaced by the `presets` state node.

### Errors

`{"id", "error": {"code": string, "message": string}}`. Codes:

| Code             | From         | Meaning                                                      |
|------------------|--------------|--------------------------------------------------------------|
| `unknown_method` | script       | No such method                                               |
| `bad_params`     | script       | Missing/ill-typed param, or a value out of range             |
| `not_found`      | script       | Unknown loop, chain, parameter or preset name                |
| `unavailable`    | script       | No pedalboard found, or the method doesn't apply now         |
| `internal`       | script       | The handler raised; details are in Live's Log.txt            |
| `live_offline`   | hub          | The hub has no link to the script                            |
| `timeout`        | hub          | No response within 2 s                                       |

An unknown method or a failing handler never crashes the script.

## 6. Versioning

- `version` in the snapshot is the protocol version (semver, as at the top).
- Adding a module, a field or a method is a **minor** bump; clients ignore modules, fields, events and error codes they don't know, and don't depend on field order.
- Removing or retyping a field, or changing a method's meaning, is a breaking bump (0.x: minor, then major from 1.0).
- A client supports one major (0.x: one minor) and shows "incompatible version" for a different one rather than guessing.
- The hub doesn't interpret `version`; it forwards the script's.

## 7. Reconnect

- **Hub - script:** the hub reconnects with exponential backoff (0.5 s doubling to 5 s). The script sends a full `state.snapshot` first on every new connection. The hub replaces its cache with it and forwards it to every client. While disconnected the hub sets `hub.live_connected` false, sends `hub.status`, keeps the stale cache and answers requests with `live_offline`.
- **Client - hub:** the client reconnects with backoff (0.5 s doubling to 5 s, with jitter) and finds the hub by name (`fc200.local`), not IP. On connect the hub sends `state.snapshot` (cache + `hub`) and then `hub.status`. A client replaces its whole state with each snapshot.
- Open requests fail when their connection drops; requests are not retried automatically.
- The script closes its socket on `disconnect()` (`SO_REUSEADDR`), so a reload doesn't leave the port bound.
- If the hub has never connected to the script, it sends no snapshot, only `hub.status` with `live_connected` false (mock mode uses `protocol/fixtures/snapshot.json` instead).

## Fixture

`protocol/fixtures/snapshot.json` is a full snapshot (as a hub client receives it, with
the `hub` node) in `parameter_control` mode with a fired scene. It is the contract for
the mock hub and for tests.

## Open questions

1. **`hub.status` vs `hub` node:** both carry `live_connected`. Keep both, or drop the event and let the hub patch `hub.live_connected`?
2. **Scene control:** no `scene.select` / `scene.fire` method in 0.1.0 (the brief names only `page.set`, `chain.select`, `param.set`, `preset.*`). Add them?
3. **Entering edit mode:** no way yet to start `parameter_control` or to pick the expression pedal's target (`picked` / `selected`) from a client. Add `edit.open {loop}`, `edit.close`, `param.pick`?
4. **`transport` node:** added beyond the brief's module list (playing/metronome are real LED state). Keep?
5. **`presets.last`:** the script keeps no such value today; it would be set by the frontend `PresetEvents` subscriber (saved or recalled?).
6. **`param.set` scope:** limited to macros and the favorite for now. Any parameter, or the loop on/off too?
7. **Out-of-range scenes:** `window` omits missing neighbours (shorter list), unlike `MiraGUI`, which sends blanks. Fixed 7 slots with `null` instead?
8. **Backoff numbers** (0.5 s to 5 s) and the 2 s timeout come from a guess/the build plan; tune on the stage network.
9. **`preset.store` without a scene:** require `scene_index`, or default to the selected scene as the pedal does? (presets.md open question 3, store by name, is still open.)
10. **Missing pedalboard:** `loops` is `[]` and `presets`/`edit` are missing; confirm that is what clients should expect.
