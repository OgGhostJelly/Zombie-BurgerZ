extends Node


@export var bonus_game_speed: float = 0.0


func _ready() -> void:
	data_load()


func data_save() -> void:
	var file := FileAccess.open("user://settings.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({
		bonus_game_speed = bonus_game_speed,
	}))


func data_load() -> void:
	var file := FileAccess.open("user://settings.json", FileAccess.READ)
	if file == null:
		return
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	bonus_game_speed = data.bonus_game_speed
