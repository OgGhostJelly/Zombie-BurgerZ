extends Node


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _scene: PackedScene
var _scene_path: String


func to_packed(scene: PackedScene) -> void:
	if animation_player.is_playing():
		push_warning("can't change the scene since it is already in a transition")
		return
	
	_scene = scene
	animation_player.play(&"swipe")


func to_file(path: String) -> void:
	if animation_player.is_playing():
		push_warning("can't change the scene since it is already in a transition")
		return
	
	_scene_path = path
	animation_player.play(&"swipe")


func _warp() -> void:
	if _scene:
		get_tree().change_scene_to_packed(_scene)
	elif _scene_path:
		get_tree().change_scene_to_file(_scene_path)
	_scene = null
	_scene_path = ""
