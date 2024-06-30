extends Node


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _scene: PackedScene
var _scene_path: String


func is_transitioning() -> bool:
	return animation_player.is_playing()


func to_packed(scene: PackedScene) -> void:
	if is_transitioning():
		return
	
	_scene = scene
	animation_player.play(&"swipe")


func to_file(path: String) -> void:
	if is_transitioning():
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
	Engine.time_scale = 1.0
	get_tree().paused = false
