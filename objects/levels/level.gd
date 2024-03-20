extends Node2D
class_name Level

signal door_entered(type: DoorType)

enum DoorType {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

const DIRECTION: Dictionary = {
	DoorType.UP: Vector2i.UP,
	DoorType.DOWN: Vector2i.DOWN,
	DoorType.LEFT: Vector2i.LEFT,
	DoorType.RIGHT: Vector2i.RIGHT,
}

@export var is_door_up: bool = true
@export var is_door_down: bool = true
@export var is_door_left: bool = true
@export var is_door_right: bool = true

@onready var door_up: Area2D = $DoorUp
@onready var door_down: Area2D = $DoorDown
@onready var door_left: Area2D = $DoorLeft
@onready var door_right: Area2D = $DoorRight

var doors: Array:
	get:
		var arr: Array = []
		if is_door_up:
			arr.append(door_up)
		if is_door_down:
			arr.append(door_down)
		if is_door_left:
			arr.append(door_left)
		if is_door_right:
			arr.append(door_right)
		return arr



func _ready() -> void:
	if not is_door_up:
		door_up.queue_free()
	if not is_door_down:
		door_down.queue_free()
	if not is_door_left:
		door_left.queue_free()
	if not is_door_right:
		door_right.queue_free()


func _on_door_up_body_entered(player: Player) -> void:
	if player == null:
		return
	
	door_entered.emit(DoorType.UP)


func _on_door_down_body_entered(player: Player) -> void:
	if player == null:
		return
	
	door_entered.emit(DoorType.DOWN)


func _on_door_right_body_entered(player: Player) -> void:
	if player == null:
		return
	
	door_entered.emit(DoorType.RIGHT)


func _on_door_left_body_entered(player: Player) -> void:
	if player == null:
		return
	
	door_entered.emit(DoorType.LEFT)
