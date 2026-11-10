from . import Listener

class DeviceParameter:
    name: str
    value: float
    is_enabled: bool

    def add_value_listener(self, listener: Listener) -> None: ...
    def remove_value_listener(self, listener: Listener) -> None: ...
    def value_has_listener(self, listener: Listener) -> bool: ...
