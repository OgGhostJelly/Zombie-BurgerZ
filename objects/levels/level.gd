extends Node2D


@onready var player: Player = $Player
@onready var debug_info: Control = $FrontLayer/DebugInfo


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		debug_info.visible = not debug_info.visible
