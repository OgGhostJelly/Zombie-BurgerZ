extends PackedSceneSupplier
class_name SinglePackedSceneSupplier
## Supplies [member scene].


## The scene.
@export var scene: PackedScene


func supply() -> PackedScene:
	return scene
