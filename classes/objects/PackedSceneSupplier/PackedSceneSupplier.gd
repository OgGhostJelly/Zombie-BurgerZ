extends Resource
class_name PackedSceneSupplier
## Represents a supplier of bullets.


## Returns the scene or [code]null[/code].
func supply() -> PackedScene:
	return null


## Returns an instance of the scene or [code]null[/code].
func supply_instance() -> Node:
	var scene: PackedScene = supply()
	if scene == null:
		return null
	
	return scene.instantiate()
