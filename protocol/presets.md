# Presets protocol

**Version 0.2.0**. Semver: minor for additions, major for breaking changes (0.x: minor may break).

| Version | Change                                                                          |
|---------|---------------------------------------------------------------------------------|
| 0.2.0   | `PresetManager` takes a `Listeners` registry; `disconnect()` only cancels       |
| 0.1.0   | First version                                                                   |

| Part                        | Status                                   |
|-----------------------------|------------------------------------------|
| 1. Preset files             | Implemented (`src/presets.py`)           |
| 2. Core API and events      | Implemented (`src/presets.py`)           |
| 3. Remote interface         | **Draft, not implemented.** Needs approval. |

A preset is the state of the pedalboard loops: for each loop (a rack on chain 0 of
the "FC200 Pedalboard" rack), its first 8 parameter values and its selected chain.
A preset is named after a clip: launching a clip with that name on the pedalboard
track recalls it.

## 1. Preset files

All files live in one folder (`config.Settings.PRESET_FOLDER`):

```
<folder>/
  template.alc.xml       dummy clip template (plain XML), maintained by hand
  _json/<name>.json      the preset
  <name>.alc             dummy clip named <name>, gzipped XML; drag it from Live's browser
```

`<name>.json` is an object keyed by **board device index** (a string, because it's JSON):

```json
{
  "0": {
    "parameters": [0.0, 0.0, 77.6, 82.7, 1.0, 127.0, 126.0, 0.0],
    "chain": "POG"
  },
  "6": {
    "parameters": [1.0, 55.0, 51.0, 41.0, 20.0, 127.0, 0.0, 0.0]
  }
}
```

| Field        | Type          | Notes                                                        |
|--------------|---------------|--------------------------------------------------------------|
| key          | string of int | Board device index (`config.Settings.LOOP_MAPPING` entries)  |
| `parameters` | float[]       | Parameter values 0..n in device order; the store writes 8    |
| `chain`      | string        | Optional. Name of the selected chain; matched by name on recall |

- **Reading:** a recall skips parameters that are disabled in Live, and a chain name that no longer exists.
- **Writing:** the JSON is indented by 2 spaces. Python, Node and Max JS consumers all read the same file.

## 2. Core API and events

This part is in-process Python, used by the Remote Script's adapters (`FC200.py` and
`preset_feedback.py` today, a frontend adapter later). Call it on Live's main
thread only.

### `PresetManager`

| Member                      | What it does                                                          |
|-----------------------------|-----------------------------------------------------------------------|
| `store(scene_index)`        | Store the board as the preset named after the clip on that scene      |
| `cancel() -> bool`          | Cancel a pending overwrite; False if none was pending                 |
| `recall(name) -> bool`      | Apply a preset on Live's next tick; False if it doesn't exist         |
| `preset_names() -> list`    | Stored preset names, sorted                                           |
| `pending_overwrite`         | Name waiting for overwrite confirmation, or None                      |
| `subscribe(listener)`       | Register a `PresetEvents` listener (any number)                       |
| `disconnect()`              | Cancel a pending overwrite                                            |

The manager's Live listener (recall on clip launch) is added to the `Listeners`
registry passed to its constructor. Whoever owns that registry removes it with
`remove_all()`.

**Store flow:**
1. **Empty slot:** the dummy clip in slot 0 is copied into it, and the store stops there. Rename the clip, then store again.
2. **Existing preset:** the store asks for confirmation instead of saving. A second `store()` for the **same** name overwrites; `cancel()` drops it. If a different preset is pending, it's cancelled first.
3. **Otherwise:** the JSON and the `.alc` are written.

**Recall:** launching a clip on the pedalboard track recalls the preset with the clip's name, if one exists.

### `PresetEvents`

Subclass it and override what you need; the defaults do nothing.

| Event                              | When                                                      |
|------------------------------------|-----------------------------------------------------------|
| `overwrite_pending(name)`          | `store()` found an existing preset: confirm or cancel     |
| `overwrite_cancelled(name)`        | A pending overwrite was cancelled                         |
| `saved(name)`                      | The preset was written                                    |
| `save_failed(name)`                | Writing failed; the details are in Live's Log.txt         |
| `recalled(name)`                   | The preset was applied to the board                       |
| `template_clip_copied(scene_index)`| An empty slot got a copy of the dummy clip                |
| `template_clip_missing()`          | An empty slot, and no dummy clip in slot 0 to copy        |

## 3. Remote interface (DRAFT)

> **Not implemented. Nothing below is final until approved.** This is how a
> frontend (web, Node, M4L) would drive presets. Only the Remote Script can read
> and write the rack, so a frontend sends commands to it and listens for the
> events above.

### Proposed transport

TCP with newline-delimited JSON, following the ableton-dev conventions:
- **Request:** `{"id", "method", "params"}`
- **Response:** `{"id", "result"}` or `{"id", "error": {"code", "message"}}`
- **Event:** `{"event", "data"}`, pushed unsolicited on the same connection

Every request gets an answer, and lists can be large, which OSC/UDP doesn't handle
well. Section 3.3 maps the same messages to OSC for clients that only speak OSC.

### Methods

| Method                 | Params                 | Result                                   |
|------------------------|------------------------|------------------------------------------|
| `preset.list`          | none                   | `{"names": [string]}`                    |
| `preset.get`           | `{"name"}`             | the preset object from section 1         |
| `preset.store`         | `{"scene_index"}`      | `{}`; the outcome arrives as an event    |
| `preset.cancel`        | none                   | `{"cancelled": bool}`                    |
| `preset.recall`        | `{"name"}`             | `{"found": bool}`                        |
| `preset.state`         | none                   | `{"pending_overwrite": string or null}`  |

### Events

Each event in section 2 becomes `{"event": "preset.<event>", "data": {...}}`. For example:
- `{"event": "preset.saved", "data": {"name": "Song A"}}`
- `{"event": "preset.template_clip_copied", "data": {"scene_index": 3}}`

### 3.3 OSC mapping (alternative)

The project prefix follows the convention for custom addresses:
- **Commands:** `/fc200/preset/store i`, `/fc200/preset/recall s`, `/fc200/preset/cancel`, `/fc200/preset/list` (reply `/fc200/preset/names s...`).
- **Events:** `/fc200/preset/<event> s`, for example `/fc200/preset/saved "Song A"`.

### Open questions

1. **Transport:** TCP JSON-lines, OSC, or both? There's also the option of extending AbletonOSC instead of adding a second gateway.
2. **Port numbers.** 20022 is taken by OSCremote, and 8001 by MiraGUI.
3. **Store by name:** should a frontend store by name (`preset.store {"name"}`) without a clip, or always via a scene's clip as the pedal does?
4. **More methods:** delete, rename, or copy preset?
5. **Mock gateway:** a fake implementation of this interface, so the frontend can be built without Live running.
