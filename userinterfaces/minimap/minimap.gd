extends GridContainer


@export var selected_texture: Texture2D
@export var tile_texture: Texture2D
@export var unknown_texture: Texture2D
var tiles: Array[Array] = []
var grid_size: Vector2i = Vector2i.ZERO


func _ready() -> void:
	update_grid_size(Vector2i(columns, columns))


func update_minimap(camera_pos: Vector2i, t: Dictionary) -> void:
	for y in grid_size.y:
		for x in grid_size.x:
			var tile = get_tile(Vector2i(x, y))
			var pos = camera_pos + Vector2i(x, y) - Vector2i(grid_size / 2.0)
			
			if t.has(pos):
				tile.texture = selected_texture if camera_pos == pos else tile_texture
				tile.modulate = Color.WHITE
				continue
			
			tile.modulate = Color.TRANSPARENT
			
			var up = t.get(pos + Vector2i.UP)
			if up and up.is_door_down:
				tile.texture = unknown_texture
				tile.modulate = Color.WHITE
			
			var down = t.get(pos + Vector2i.DOWN)
			if down and down.is_door_up:
				tile.texture = unknown_texture
				tile.modulate = Color.WHITE
			
			var left = t.get(pos + Vector2i.LEFT)
			if left and left.is_door_right:
				tile.texture = unknown_texture
				tile.modulate = Color.WHITE
			
			var right = t.get(pos + Vector2i.RIGHT)
			if right and right.is_door_left:
				tile.texture = unknown_texture
				tile.modulate = Color.WHITE


func update_grid_size(value: Vector2i) -> void:
	for y in value.y:
		var row: Array = []
		tiles.append(row)
		
		for x in value.x:
			var tile: Control = TextureRect.new()
			add_child(tile)
			row.append(tile)
	
	grid_size = value


func get_tile(at: Vector2i) -> Control:
	return tiles[at.y][at.x]
