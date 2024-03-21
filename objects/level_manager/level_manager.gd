extends Node2D


@export var _level_scenes: Array[PackedScene] = []

@onready var player: Player = $Player
@onready var debug_info: Control = $FrontLayer/DebugInfo
@onready var minimap: Control = $FrontLayer/ColorRect/Minimap

var levels: Dictionary = {}
var current_position: Vector2i = Vector2i.ZERO


func _ready() -> void:
	add_level(current_position)
	
	var arr: Array[Level.DoorType] = []
	
	if levels[current_position].is_door_up:
		arr.append(Level.DoorType.DOWN)
	if levels[current_position].is_door_down:
		arr.append(Level.DoorType.UP)
	if levels[current_position].is_door_left:
		arr.append(Level.DoorType.RIGHT)
	if levels[current_position].is_door_right:
		arr.append(Level.DoorType.LEFT)
	
	update_player_position(arr.pick_random())
	minimap.update_minimap(current_position, levels)


func remove_current_level() -> void:
	var level: Level = levels.get(current_position)
	if is_instance_valid(level):
		call_deferred(&"remove_child", level)


func add_level(at: Vector2i) -> void:
	var level = get_level(at)
	
	call_deferred(&"add_child", level)
	
	for bullet in get_tree().get_nodes_in_group(&"bullets"):
		bullet.queue_free()


func update_player_position(door: int) -> void:
	match door:
		Level.DoorType.UP: player.global_position = Vector2(480.0 / 2.0, 360.0) + Vector2(0.0, -48.0)
		Level.DoorType.DOWN: player.global_position = Vector2(480.0 / 2.0, 0.0) + Vector2(0.0, 48.0)
		Level.DoorType.LEFT: player.global_position = Vector2(480.0, 360.0 / 2.0) + Vector2(-48.0, 0.0)
		Level.DoorType.RIGHT: player.global_position = Vector2(0.0, 360.0 / 2.0) + Vector2(48.0, 0.0)
		_: push_warning("Unexpected `DoorType` in `update_player_position`")


func move_to(from: Level.DoorType, to: Vector2i) -> void:
	remove_current_level()
	update_player_position(from)
	
	# We want to spawn the level after the players position has been updated.
	# since godot takes one frame to update the position of nodes, we wait.
	await get_tree().process_frame
	
	current_position = to
	
	add_level(current_position)
	
	minimap.update_minimap(current_position, levels)


func get_level(at: Vector2i) -> Level:
	if levels.get(at):
		return levels[at]
	
	var obj: Level
	
	for i in 32:
		var value: Level = _level_scenes.pick_random().instantiate()
		
		var up: Level = levels.get(at + Vector2i.UP)
		if is_instance_valid(up) and up.is_door_down != value.is_door_up:
			continue
		
		var down: Level = levels.get(at + Vector2i.DOWN)
		if is_instance_valid(down) and down.is_door_up != value.is_door_down:
			continue
		
		var left: Level = levels.get(at + Vector2i.LEFT)
		if is_instance_valid(left) and left.is_door_right != value.is_door_left:
			continue
		
		var right: Level = levels.get(at + Vector2i.RIGHT)
		if is_instance_valid(right) and right.is_door_left != value.is_door_right:
			continue
		
		obj = value
		break
	
	# If no level is found, generate a default empty one.
	if obj == null:
		obj = preload("res://objects/levels/level.tscn").instantiate()
		
		var up: Level = levels.get(at + Vector2i.UP)
		if is_instance_valid(up):
			obj.is_door_up = up.is_door_down
		
		var down: Level = levels.get(at + Vector2i.DOWN)
		if is_instance_valid(down):
			obj.is_door_down = down.is_door_up
		
		var left: Level = levels.get(at + Vector2i.LEFT)
		if is_instance_valid(left):
			obj.is_door_left = left.is_door_right
		
		var right: Level = levels.get(at + Vector2i.RIGHT)
		if is_instance_valid(right):
			obj.is_door_right = right.is_door_left
	
	obj.door_entered.connect(func(from):
		if get_tree().get_nodes_in_group(&"enemies").size() > 0:
			return
		
		move_to(from, current_position + Level.DIRECTION[from]))
	
	levels[at] = obj
	
	return obj


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		debug_info.visible = not debug_info.visible
	
	if is_instance_valid(levels.get(current_position)):
		for door in levels[current_position].doors:
			door.visible = get_tree().get_nodes_in_group(&"enemies").size() <= 0
	
	$FrontLayer/DebugInfo/LevelLabel.text = "Level: %s" % levels.get(current_position).name
	$FrontLayer/DebugInfo/PositionLabel.text = "Position: %s" % current_position
