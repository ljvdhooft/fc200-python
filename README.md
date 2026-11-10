# fc200-python

MIDI Remote Script for Ableton Live that turns a Roland FC-200 floor pedal (in
Exclusive/SysEx mode) into a pedalboard controller. See `CLAUDE.md` for how it
is put together.

## Debugging

Follow the script's messages and errors in Live's log while you play:

```sh
tail -f -n 0 ~/Library/Preferences/Ableton/"Live 12.4b14"/Log.txt | grep --line-buffered -E "\(FC200\)|RemoteScriptError"
```

- `tail -f -n 0`: follow the file as it grows, starting from now (no old lines).
- `grep --line-buffered -E`: show each matching line immediately instead of
  buffering, matching either pattern:
  - `\(FC200\)`: messages from this script (`log_message`, listener errors).
  - `RemoteScriptError`: Python tracebacks from any Remote Script.

Change `Live 12.4b14` when you update Live; each version has its own `Log.txt`.
