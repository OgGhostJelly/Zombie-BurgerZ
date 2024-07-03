@tool
extends FloatingMenuButton


@export var scene: PackedScene
@export_file var scene_filepath: String
@export var animation: StringName = SceneTransition.SWIPE


func _ready() -> void:
	assert(scene or scene_filepath, "%s" % self)
	super()


func _on_pressed() -> void:
	super()
	if scene:
		SceneTransition.to_packed(scene, animation)
	elif scene_filepath:
		SceneTransition.to_file(scene_filepath, animation)
