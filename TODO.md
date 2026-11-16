# TODO

- [x] Replace `MiraGUI` with a frontend: Python hub + web app (`docs/frontend-architecture.md`).
- [x] WP6: remove Mira (`MiraGUI.py`, `FC200 Mira.amxd`).
- [ ] Test Freeze. With emulator it looks fixed.
- [x] Bug: Nowplaying doesn't update when launching scene from "stop" state.
- [x] Refactor: MIDI loopback into Ableton. The script's own output can't loop back (Live jams the IAC track input), so the ForScore pedals go through the hub (`midi.send`, protocol 0.15.0).
- [x] Feat: Add "preset name" next to scene name in frontend if there is a clip on the eGit track. Both "scene name" and "preset name" (.alc clip)
- [x] Feat: Add preset name edit support in WebUI.
- [ ] Feat: Add/delete/reorder scenes from webUI. "Edit" toggle button allows to edit scenes.
- [ ] Come up with an easier workflow for saving presets.
- [ ] Preset housekeeping: the `.alc` files lead (managed in Live's browser), so renaming or deleting one must carry its `.json` along. Today they are a loose pair matched by file name; renames orphan the `.json` (24 orphans and `Untitled.alc` without one, 2026-11-11). Options to weigh:
  - **One file:** keep the preset values inside the `.alc` itself (e.g. in the clip's annotation/info text), so there is nothing to keep in sync. Check whether Live preserves that field and whether the script can read it from the launched clip.
  - **Stable id:** write an id into the `.alc` and name the `.json` after the id instead of the clip name, so a rename keeps the link.
  - **Reconcile:** a sweep (on script load or on demand) that matches orphans by content or modification time, renames the `.json` and reports what it can't resolve. Deletes move the `.json` to `_json/_trash/` rather than removing it.
