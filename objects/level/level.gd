extends Node2D


@export var structure_scenes: Array[PackedScene]
@export var enemy_supplier: PackedSceneSupplier
@export var tile_size: Vector2 = Vector2(32.0, 32.0)
@export var generation_size: Vector2i = Vector2i(25, 25)

@onready var player: Player = $Player
@onready var debug_info: Control = $FrontLayer/DebugInfo

var generated_tiles: Dictionary = {}


func global_to_tile(pos: Vector2) -> Vector2i:
	return (pos - (tile_size / 2.0)).snapped(tile_size) / tile_size


func tile_to_global_corner(pos: Vector2i) -> Vector2:
	return (Vector2(pos.x, pos.y) * tile_size)


func tile_to_global_center(pos: Vector2i) -> Vector2:
	return tile_to_global_corner(pos) + (tile_size / 2.0)


func _ready() -> void:
	iterate_generation_tiles(func(pos: Vector2i) -> void:
		generated_tiles[pos] = true)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		debug_info.visible = not debug_info.visible
	
	iterate_generation_tiles(func(pos: Vector2i) -> void:
		if generated_tiles.has(pos):
			return
		
		if randf() > 0.99:
			var obj: Node2D = structure_scenes.pick_random().instantiate()
			if obj == null:
				push_warning("Failed to spawn enemy instance!")
				return
			obj.global_position = tile_to_global_corner(pos)
			add_child(obj)
		elif randf() > 0.99:
			var obj: Node2D = enemy_supplier.supply_instance()
			if obj == null:
				push_warning("Failed to spawn enemy instance!")
				return
			obj.global_position = tile_to_global_corner(pos)
			add_child(obj)
		
		generated_tiles[pos] = true)


func iterate_generation_tiles(f: Callable) -> void:
	for y in generation_size.y:
		for x in generation_size.x:
			var pos: Vector2i = Vector2i(x, y) - (generation_size / 2) + global_to_tile(player.global_position)
			f.call(pos)


# Visualize generation_size
	#for y in generation_size.y:
		#for x in generation_size.x:
			#var pos: Vector2i = Vector2i(x, y) - (generation_size / 2) + global_to_tile(player.global_position)
			#
			#var ratio_x: float = float(x) / generation_size.x
			#var ratio_y: float = float(y) / generation_size.y
			#
			#draw_rect(Rect2(to_local(tile_to_global_corner(pos)), tile_size), Color(ratio_x, ratio_y, 1.0 - ratio_x - ratio_y))
