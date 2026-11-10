# Type stubs for Live

Type-only descriptions (`.pyi`) of the parts of Ableton Live's Python API that
this Remote Script uses. mypy reads them via `mypy_path = stubs` in `mypy.ini`;
Live never loads them. They are partial on purpose: add a member here when the
script starts using it.

Module and class names mirror Live's own (`Live.Song.Song`, `Live.Track.Track`,
`_Framework.Task`, ...), so `TYPE_CHECKING` imports read like the real thing.
