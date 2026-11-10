from collections.abc import Sequence

from .Chain import Chain
from .Device import Device

class RackDevice(Device):
    class View:
        selected_chain: Chain

    view: View
    chains: Sequence[Chain]
