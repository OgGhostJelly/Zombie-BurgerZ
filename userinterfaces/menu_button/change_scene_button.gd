@tool
extends FloatingMenuButton


@export var scene: PackedScene
@export_file var scene_filepath: String


func _ready() -> void:
	assert(scene or scene_filepath, "%s" % self)
	super()


func _on_pressed() -> void:
	super()
	if scene:
		SceneTransition.to_packed(scene)
	elif scene_filepath:
		SceneTransition.to_file(scene_filepath)
