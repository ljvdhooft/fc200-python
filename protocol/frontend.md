# Frontend protocol

**Version 0.13.0**. Semver: minor for additions, major for breaking changes (0.x: minor may break).

| Version | Change                                                                  |
|---------|-------------------------------------------------------------------------|
| 0.1.0   | First version; folds in and supersedes `presets.md` §3                  |
| 0.2.0   | `favorite` node replaces `loops[].favorite.picked`                      |
| 0.3.0   | Approved. `state.dump`/`state.changed`, loop-tree methods, scene and edit methods, `pedalboard` node |
| 0.4.0   | `state.dump` method: ask for the full state again without reconnecting |
| 0.5.0   | `presets.names` replaced by `presets.count`; names via `preset.list`   |
| 0.6.0   | Presets are listed from the `.alc` files; `preset.list` adds `missing_json` |
| 0.7.0   | `scene.list`: every scene in the set, for browsing                      |
| 0.8.0   | `scene.fired` event; `scenes.fired` also follows launches in Ableton    |
| 0.9.0   | `transport.play`, `transport.stop`, `metronome.set`, `scene.fire_and_stop` |
| 0.10.0  | `tuner` node: note, cents and tolerance while the volume is 0          |
| 0.11.0  | `loops[].macros`: every loop carries its 8 macros                       |
| 0.12.0  | `loop.param.displays`: a macro's display text for each of its 128 steps |
| 0.13.0  | `tempo.set`                                                              |

| Part                  | Status                                     |
|-----------------------|--------------------------------------------|
| 1. Transports         | Approved, implemented                      |
| 2. Messages           | Approved, implemented                      |
| 3. State tree         | Approved, implemented                      |
| 4. Changes            | Approved, implemented                      |
| 5. Methods            | Approved, implemented (mock hub: 0.2 methods only) |
| 6. Versioning         | Approved                                   |
| 7. Reconnect          | Approved, implemented                      |

The Remote Script is the single source of truth for the FC200 state. It pushes
the state to a **hub** (`apps/hub`), which relays it to **clients** (web app,
future hardware display). Clients send requests, which the hub relays back to the
script. Design background: `docs/frontend-architecture.md`.

The words "snapshot", "patch", "preset" and "scene" are avoided for protocol
mechanics: on a pedalboard they already mean a sound or a song part. The full
state is a **dump**, an update to it is a set of **changes**.

## 1. Transports

| Link          | Transport                   | Address                              |
|---------------|-----------------------------|--------------------------------------|
| script - hub  | TCP, newline-delimited JSON | `127.0.0.1:20030` (script listens)   |
| hub - client  | WebSocket, one JSON per text frame | `ws://<host>:20031/ws` (hub listens) |

- The **script is the server**, so Live can restart without any client logic in the script. It accepts several connections (the hub, plus `nc` for debugging).
- JSON lines: UTF-8, one message per line, terminated by `\n`, no embedded newlines.
- The hub serves the web app on the same port (`http://<host>:20031/`) and advertises itself as `fc200.local` (mDNS).
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
- Naming: methods are `<object>.<verb>` along the Live tree (`loop.chain.select`); events are past tense or a noun (`state.changed`, `preset.saved`, `state.dump`), so an event never reads like a command.

### Events

| Event                | Data                          | From          | When                                             |
|----------------------|-------------------------------|---------------|--------------------------------------------------|
| `state.dump`         | the full state tree           | script, hub   | On connect, on every reconnect, and after a `state.dump` request |
| `state.changed`      | `{"<path>": value, ...}`      | script, hub   | At most once per `update_display` tick, never empty |
| `hub.status`         | `{"live_connected": bool}`    | hub           | On client connect, and when the Live link changes |
| `preset.<event>`     | see below                     | script        | A `PresetEvents` call (transient, not in state)  |
| `scene.fired`        | `{index, name, color}`        | script        | Every scene launch (pedal, `scene.fire`, Ableton) |

`hub.status` and the `hub` node both carry `live_connected`: the event suits simple
clients that only show a connection light, the node keeps a dump self-contained.

Preset events carry the arguments of the matching `PresetEvents` method
(`presets.md` §2): `preset.overwrite_pending {"name"}`, `preset.overwrite_cancelled {"name"}`,
`preset.saved {"name"}`, `preset.save_failed {"name"}`, `preset.recalled {"name"}`,
`preset.template_clip_copied {"scene_index"}`, `preset.template_clip_missing {}`.
The durable part (`pending_overwrite`, `count`, `last`) is also in the state tree, so
a client that misses an event still converges.

`scene.fired` comes from each scene's `Scene.is_triggered` listener, so it covers
launches from the pedal, `scene.fire` and Ableton itself. Firing the same
scene again leaves `scenes.fired` unchanged (so no `state.changed`), but it is still
an event: a client that shows whether the fired scene is playing needs every fire.

## 3. State tree

The dump is a JSON object. Modules are top-level keys; a client ignores keys
it doesn't know. **Missing and `null` mean the same** ("none"): a producer may send
either in a dump, and a change sets `null` by deleting the key (section 4).
`value` is always the **normalised** value (0..1, i.e. `(value - min) / (max - min)`
of the `DeviceParameter`) and `display` is Live's string for it
(`str_for_value(value)`), so clients never need parameter ranges.

### Root

| Field       | Type   | Meaning                          | Source                                  |
|-------------|--------|----------------------------------|-----------------------------------------|
| `version`   | string | Protocol version, `"0.6.0"`      | constant in the script                  |
| `page`      | int    | Active page, `MIN_PAGE..MAX_PAGE` (0 transport, 1 loops, 2 favorites) | `FC200._page` |
| `mode`      | string | `"transport"`, `"loops"`, `"favorites"` or `"parameter_control"` | class of `FC200._mode` (`TransportPage`, `LoopsPage`, `FavoritesPage`, `ParameterControl`) |
| `tempo`     | float  | Song tempo in BPM                | `Song.tempo` (listener)                 |

`mode` equals the page name except while `ParameterControl` is active (it sits on page 2).

### `pedalboard`

Whether the script found the "FC200 Pedalboard" rack. Always present, so a client
can tell "no pedalboard" from "not connected" and point at the fix.

| Field    | Type        | Meaning                                         | Source                          |
|----------|-------------|-------------------------------------------------|---------------------------------|
| `found`        | bool        | A rack named "FC200 Pedalboard" was found  | `FC200._has_pedalboard`         |
| `track`        | string/null | Name of the track holding it               | `FC200._track.name`             |
| `track_index`  | int/null    | Index of that track (0-based)              | `FC200._track_index`            |
| `device`       | string/null | Name of the rack                           | `FC200._device.name`            |
| `device_index` | int/null    | Its device index on that track (0-based)   | `FC200._device_index`           |

It lives in the script's tree, not in `hub`: only the script can look for the rack.
Without a pedalboard, `loops` is an empty list and `favorite`, `edit` and `presets`
are missing; methods that need it answer `unavailable`.

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
| `fired`    | object/null | Scene last launched (pedal, `scene.fire` or Ableton): `{index, name, color}` | `FC200._fired_scene` (`Scene.is_triggered` listener) |
| `window`   | list        | Scenes `selected-3 .. selected+3`, clipped to existing scenes, in order | `Song.scenes` |

A `window` / `fired` entry: `index` (int), `name` (string, `Scene.name`), `color`
(int, `Scene.color`, `0xRRGGBB`). The window replaces `MiraGUI.scene_overview`
(`prev3..next3`, `cur`); the current scene is the entry whose `index` equals `selected`.
Near the start or end of the set the window is shorter; clients lay it out by `index`.
The full list isn't in the state (a set can have hundreds of scenes); a client that
browses it asks `scene.list`, and asks again when `count` changes or when it starts
browsing (a renamed or recoloured scene doesn't change `count`). Entries in `window`
and `fired` are always current.

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
| `macros`   | list        | The loop's 8 macros, in parameter order                  | `RackDevice.parameters[1..8]`                        |

`favorite`:

| Field       | Type   | Meaning                                                      | Source                                      |
|-------------|--------|--------------------------------------------------------------|---------------------------------------------|
| `parameter` | int    | Parameter index within the loop                              | `FAVORITE_PARAMETERS[n]`                    |
| `name`      | string | Parameter name                                               | `DeviceParameter.name`                      |
| `value`     | float  | Normalised value                                             | `DeviceParameter.value`                     |
| `display`   | string | Live's display string                                        | `DeviceParameter.str_for_value`             |

A `macros` entry: `parameter` (int, 1..8), `name`, `value`, `display` (as for
`favorite`). Clients edit a loop with them without entering `parameter_control`
(`loop.param.set`); `edit.macros` adds the pedal mapping for that mode.

Which favorite the expression pedal controls is page-wide state, in the `favorite` node.

### `favorite`

The favorite the expression pedal controls on page 2 (`FavoritesPage`), between
selecting it with a number pedal and either dropping it (CTL, leaving the page) or
pressing the same pedal again to enter `parameter_control`. Missing/`null` otherwise.

| Field       | Type   | Meaning                                         | Source                                   |
|-------------|--------|-------------------------------------------------|------------------------------------------|
| `loop`      | int    | Board device index of the loop (`loops[].index`)| `LOOP_MAPPING[FavoritesPage.pedal]`      |
| `pedal`     | int    | Number pedal that selected it (1-based)         | `FavoritesPage.pedal` + 1                |
| `loop_name` | string | Loop name                                       | `RackDevice.name`                        |
| `parameter` | int    | Parameter index within the loop                 | `FAVORITE_PARAMETERS[pedal]`             |
| `name`, `value`, `display` | | As for `loops[].favorite`                | `FavoritesPage.parameter`                |

There is one selected favorite for the page (`FavoritesPage.pedal` / `.parameter`),
so it is a single node rather than a flag per loop.

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
| `count`             | int         | Number of presets (`.alc` files)                     | `len(PresetManager.preset_names())`              |
| `pending_overwrite` | string/null | Preset waiting for overwrite confirmation            | `PresetManager.pending_overwrite`                |
| `last`              | string/null | Name of the last preset saved or recalled            | `PresetEvents.saved` / `recalled` (subscriber)   |

Missing when the script found no pedalboard (`PresetManager` is None).

A preset is listed by its `.alc` file: that is the file the user sees and manages
in Live's browser, so it leads. Its `.json` (the parameter values) is what a recall
applies; an `.alc` without one can't be recalled, and `preset.list` reports it. A
`.json` without an `.alc` is not listed (and left alone on disk). Names are matched
by the file system, so as case-insensitively as macOS and Live.

The names themselves are not in the state: the list can be long and every dump would
carry it. A client that shows them asks `preset.list` and asks again when `count`
changes or a `preset.saved` event arrives.

### `tuner`

The pedalboard's tuner, present only while the volume (EXP, `LOOP_VOLUME`) is at 0,
which is when the FC-200 shows it on the bank display. Missing/`null` otherwise and
without a pedalboard. Whether a client shows it, and how, is up to the client.

| Field       | Type   | Meaning                                                       | Source                                                   |
|-------------|--------|---------------------------------------------------------------|----------------------------------------------------------|
| `note`      | string | Detected note: `"C"`, `"C#"` .. `"B"`                         | tuner device `parameters[2]` mod 12                      |
| `cents`     | float  | Deviation in cents, including the reference offset (~-50..50) | tuner `parameters[1]` - 50 + (rack `parameters[1]` - 64) |
| `in_tune`   | bool   | `abs(cents) < tolerance`, as on the bank display              | `FC200._tuner_reading`                                   |
| `tolerance` | float  | Cents either side of 0 that count as in tune                  | `config.Settings.TUNER_TOLERANCE`                        |

The tuner device is `track.devices[TUNER_RACK].chains[TUNER_CHAIN].devices[TUNER_DEVICE]`
(`config.Settings`). The values follow its listeners, so they change often while a
string sounds; the model drops repeats.

### `hub`

Added by the hub, never by the script.

| Field            | Type | Meaning                                  | Source              |
|------------------|------|------------------------------------------|---------------------|
| `live_connected` | bool | The hub has a live link to the script    | hub's TCP client    |

While `live_connected` is false the rest of the tree is the **last known** state and is stale.

## 4. Changes

`{"event": "state.changed", "data": {"<path>": value, ...}}`

- A **path** is dotted from the root. Object keys are used as-is; list elements by decimal index: `loops.2.favorite.value`, `scenes.window.3.name`, `edit.macros.0.display`. No key contains a dot.
- **Set:** the path's value becomes `value` (any JSON type). **Delete:** `null` removes the key (so "none" reads as missing; see section 3).
- A **list is replaced as a whole** when its length changes: the producer sends the full list at the list's path (`"scenes.window": [...]`, `"loops.2.chains": [...]`). Element paths are only used while the length is unchanged.
- To add an object (e.g. `edit` when entering `parameter_control`), the producer sends the full object at its path. A change whose parent path doesn't exist is ignored by the consumer (log it); the next reconnect resyncs.
- A `state.changed` contains no path that is a prefix of another. Entries are applied in object order.
- The producer coalesces: many changes within one tick yield one `state.changed`; a value equal to the current one is not sent; an empty one is never sent. Rate: at most one per `update_display` tick (about 100 ms).
- `state.changed` is applied by the hub to its cache and forwarded unchanged.

## 5. Methods

Requests go client - hub - script. The hub replaces `id` with its own and routes the
response back with the client's original `id`. Methods follow the Live tree: what
belongs to a loop (its chains, its parameters) is under `loop.`. All run on Live's
main thread, through the same code paths as the pedal. A method changes state; the
new state arrives as `state.changed` (the result does not replace it).

| Method               | Params                                            | Result                          |
|----------------------|---------------------------------------------------|---------------------------------|
| `state.dump`         | none                                              | `{}`, then a `state.dump` event |
| `page.set`           | `{"page": int}`                                   | `{"page": int}`                 |
| `scene.select`       | `{"index": int}`                                  | `{"index": int}`                |
| `scene.fire`         | none                                              | `{"index": int}` (fired scene)  |
| `scene.fire_and_stop`| none                                              | `{"index": int}` (fired scene)  |
| `transport.play`     | none                                              | `{}`                            |
| `transport.stop`     | none                                              | `{}`                            |
| `metronome.set`      | `{"on": bool}`                                    | `{"on": bool}`                  |
| `tempo.set`          | `{"tempo": float}`                                | `{"tempo": float}`              |
| `scene.list`         | none                                              | `{"scenes": [{index, name, color}]}`, in set order |
| `loop.set`           | `{"loop": int, "on": bool}`                       | `{"on": bool}`                  |
| `loop.chain.select`  | `{"loop": int, "chain": string}`                  | `{"chain": string}`             |
| `loop.param.set`     | `{"loop": int, "parameter": int, "value": float}` | `{"value": float, "display": string}` |
| `loop.param.select`  | `{"loop": int, "parameter": int}`                 | `{"parameter": int}`            |
| `loop.param.displays`| `{"loop": int, "parameter": int}`                 | `{"displays": [string]}`        |
| `edit.open`          | `{"loop": int}`                                   | `{"loop": int}`                 |
| `edit.close`         | none                                              | `{}`                            |
| `preset.list`        | none                                              | `{"names": [string], "missing_json": [string]}`, sorted |
| `preset.get`         | `{"name": string}`                                | the preset object (`presets.md` §1) |
| `preset.store`       | `{"scene_index": int}`                            | `{}`; outcome as `preset.*` event and `presets` state |
| `preset.cancel`      | none                                              | `{"cancelled": bool}`           |
| `preset.recall`      | `{"name": string}`                                | `{"found": bool}`               |

- `loop` is a board device index (`loops[].index`), not a position. `value` is normalised 0..1; the script clamps it.
- `state.dump` sends the `state.dump` event again, to the requesting connection only, right after the response. A client resyncs without reconnecting (debugging with `nc`, an iPad waking from sleep). It is the one method the hub answers itself, from its cache (including the `hub` node), so it also works while `live_connected` is false. The method shares the event's name on purpose: whatever asks for a dump handles it in the same place as any other dump.
- `page.set` calls `FC200._show_page`: it leaves `parameter_control` and drops a favorite or pending overwrite, like a bank pedal.
- `scene.select` selects a scene without launching it (`Song.view.selected_scene`). `scene.fire` does what pedal 3 does on page 0 (`TransportPage._fire_scene`): it launches the selected scene and selects the next one. It works on any page.
- `scene.fire_and_stop` does what pedal 7 does on page 0 (`TransportPage.fire_and_stop`): it fires the selected scene and stops right away, so its clips recall their presets without anything playing. Needs a pedalboard (`unavailable` otherwise).
- `transport.play` / `transport.stop` do what pedals 1 and 2 do on page 0; stop also stops all clips. Both work on any page.
- `tempo.set` sets the song tempo (`Song.tempo`) in BPM, clamped to Live's 20..999; the result is the tempo set. Works on any page.
- `metronome.set` switches the metronome on or off (`Song.metronome`), like pedal 6 on page 0. Works on any page.
- `loop.set` switches the loop on or off (parameter 0), like a number pedal on page 1.
- `loop.chain.select` matches the chain by name, like a preset recall. While the loop is being edited, the script keeps `ParameterControl`'s chain index in sync.
- `loop.param.set` accepts the macros only, `parameter` 1..8 (a loop's favorite is one of its macros). It does **not** change what the expression pedal controls.
- `loop.param.displays` returns Live's display text (`str_for_value`) for each of a macro's 128 steps: entry `i` is the text at value `i / 127`. Clients show it while dragging, before Ableton reports the new `display`; they can't format it themselves (ms, dB, ratios). Macros only, `parameter` 1..8. Ask again whenever the text may have changed (a remapped macro): the script doesn't notify.
- `loop.param.select` sets what the expression pedal controls, like a macro pedal in `parameter_control` (`ParameterControl._select_macro`). Only for the loop being edited; otherwise `unavailable`.
- `edit.open` enters `parameter_control` for a loop, like pressing a favorite's pedal twice on page 2; it goes to page 2 first if needed. `edit.close` returns to the favorites page, like CTL in `parameter_control`; outside it, it does nothing.
- `preset.store` and `preset.recall` behave exactly as `PresetManager.store` / `recall`; a second `preset.store` for the same name confirms an overwrite, `preset.cancel` drops it. `preset.store` requires `scene_index`: a remote names its target explicitly. `preset.recall` already applies a preset without launching a scene.
- `preset.state` from `presets.md` §3 is replaced by the `presets` state node.

### Errors

`{"id", "error": {"code": string, "message": string}}`. Codes:

| Code             | From         | Meaning                                                      |
|------------------|--------------|--------------------------------------------------------------|
| `unknown_method` | script       | No such method                                               |
| `bad_params`     | script       | Missing/ill-typed param, or a value out of range             |
| `not_found`      | script       | Unknown loop, chain, parameter, scene or preset name         |
| `unavailable`    | script       | No pedalboard found, or the method doesn't apply now         |
| `internal`       | script       | The handler raised; details are in Live's Log.txt            |
| `live_offline`   | hub          | The hub has no link to the script                            |
| `timeout`        | hub          | No response within 2 s                                       |

An unknown method or a failing handler never crashes the script.

## 6. Versioning

- `version` in the dump is the protocol version (semver, as at the top).
- Adding a module, a field or a method is a **minor** bump; clients ignore modules, fields, events and error codes they don't know, and don't depend on field order.
- Removing or retyping a field, or changing a method's meaning, is a breaking bump (0.x: minor, then major from 1.0).
- A client supports one major (0.x: one minor) and shows "incompatible version" for a different one rather than guessing.
- The hub doesn't interpret `version`; it forwards the script's.

## 7. Reconnect

- **Hub - script:** the hub reconnects with exponential backoff (0.5 s doubling to 5 s). The script sends a full `state.dump` first on every new connection. The hub replaces its cache with it and forwards it to every client. While disconnected the hub sets `hub.live_connected` false, sends `hub.status`, keeps the stale cache and answers requests with `live_offline`.
- **Client - hub:** the client reconnects with backoff (0.5 s doubling to 5 s, with jitter) and finds the hub by name (`fc200.local`), not IP. On connect the hub sends `state.dump` (cache + `hub`) and then `hub.status`. A client replaces its whole state with each dump.
- Open requests fail when their connection drops; requests are not retried automatically.
- The script closes its socket on `disconnect()` (`SO_REUSEADDR`), so a reload doesn't leave the port bound.
- If the hub has never connected to the script, it sends no dump, only `hub.status` with `live_connected` false (mock mode uses `protocol/fixtures/dump.json` instead).
- The backoff and timeout numbers are starting values, to be tuned on the stage network.

## Fixture

`protocol/fixtures/dump.json` is a full dump (as a hub client receives it, with
the `hub` node) in `parameter_control` mode with a fired scene. It is the contract for
the mock hub and for tests.

## Planned

- **Presets without scenes.** Storing is tied to the clip on a scene (the preset is
  named after it). Once `PresetManager` is decoupled from clip slots, add
  `preset.save {"name"}`, which stores the board under a name without a clip.
  Recall is already independent of scenes. Tracked in `presets.md` (open question 3).
- **Favorites from a client.** `favorite.select {"loop"}` / `favorite.clear`, if a
  client should drive page 2 the way the number pedals do.
