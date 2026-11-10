from collections.abc import Sequence

from .DeviceParameter import DeviceParameter

class Device:
    name: str
    parameters: Sequence[DeviceParameter]
