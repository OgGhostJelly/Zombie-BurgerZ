extends Node2D


@export var _level_scenes: Array[PackedScene] = []

@onready var player: Player = $Player
@onready var debug_info: Control = $FrontLayer/DebugInfo
@onready var minimap: Control = $FrontLayer/ColorRect/Minimap

var levels: Dictionary = {}
var current_position: Vector2i = Vector2i.ZERO


func _ready() -> void:
	try_generate_current_level()
	
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


func clear_current_level() -> void:
	var level: Level = levels.get(current_position)
	if is_instance_valid(level):
		call_deferred(&"remove_child", level)


func try_generate_current_level() -> void:
	if not levels.has(current_position):
		levels[current_position] = gen_level(current_position)
	
	call_deferred(&"add_child", levels[current_position])
	
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
	clear_current_level()
	update_player_position(from)
	
	# We have to wait a process_frame for the players position to update
	# or else they will enter multiple doors without getting their position reset.
	await get_tree().process_frame
	
	current_position = to
	
	try_generate_current_level()
	
	minimap.update_minimap(current_position, levels)


func gen_level(at: Vector2i) -> Level:
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
	
	obj.door_entered.connect(func(from):
		if get_tree().get_nodes_in_group(&"enemies").size() > 0:
			return
		
		move_to(from, current_position + Level.DIRECTION[from]))
	
	return obj


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		debug_info.visible = not debug_info.visible
	
	if is_instance_valid(levels.get(current_position)):
		for door in levels[current_position].doors:
			door.visible = get_tree().get_nodes_in_group(&"enemies").size() <= 0
	
	$FrontLayer/DebugInfo/LevelLabel.text = "Level: %s" % levels.get(current_position).name
	$FrontLayer/DebugInfo/PositionLabel.text = "Position: %s" % current_position
