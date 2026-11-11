from . import Listener

class DeviceParameter:
    name: str
    value: float
    min: float
    max: float
    is_enabled: bool

    def str_for_value(self, value: float) -> str: ...

    def add_value_listener(self, listener: Listener) -> None: ...
    def remove_value_listener(self, listener: Listener) -> None: ...
    def value_has_listener(self, listener: Listener) -> bool: ...
