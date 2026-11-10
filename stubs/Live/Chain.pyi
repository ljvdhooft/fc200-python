from collections.abc import Sequence

from .Device import Device

class Chain:
    name: str
    devices: Sequence[Device]
