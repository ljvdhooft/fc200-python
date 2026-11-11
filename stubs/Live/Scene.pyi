class Scene:
    name: str
    color: int

    def fire(self, force_legato: bool = ..., can_select_scene_on_launch: bool = ...) -> None: ...
