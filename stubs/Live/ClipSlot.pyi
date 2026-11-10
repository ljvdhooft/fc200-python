from .Clip import Clip

class ClipSlot:
    has_clip: bool
    clip: Clip

    def duplicate_clip_to(self, target: ClipSlot) -> None: ...
