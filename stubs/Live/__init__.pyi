from collections.abc import Callable

# Callback passed to the LOM's add_*_listener methods
Listener = Callable[[], None]
