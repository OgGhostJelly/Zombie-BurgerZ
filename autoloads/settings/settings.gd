extends Node


enum GameSpeed {
	GameSpeed100,
	GameSpeed120,
	GameSpeed150,
	GameSpeed200,
}

@export var game_speed: GameSpeed = GameSpeed.GameSpeed100
@export var no_move: bool = false
@export var gun_sights: bool = false
@export var volume: float = 0.0:
	set(value):
		volume = value
		AudioServer.set_bus_volume_db(0, volume)
@export var muted: bool = false:
	set(value):
		muted = value
		AudioServer.set_bus_mute(0, muted)


func get_bonus_game_speed() -> float:
	return bonus_game_speed(game_speed)


func bonus_game_speed(speed: GameSpeed) -> float:
	match speed:
		GameSpeed.GameSpeed100:
			return 0.0
		GameSpeed.GameSpeed120:
			return 0.2
		GameSpeed.GameSpeed150:
			return 0.5
		GameSpeed.GameSpeed200:
			return 1.0
	
	return 0.0


func game_speed_money_bonus(speed: GameSpeed) -> float:
	return (Settings.bonus_game_speed(speed) / 2.0)


func get_money_multiplier() -> float:
	var game_speed_bonus: float = game_speed_money_bonus(game_speed)
	var no_move_bonus: float = 0.5 if Settings.no_move else 0.0
	var gun_sights_bonus: float = -0.1 if Settings.gun_sights else 0.0
	return 1.0 + game_speed_bonus + no_move_bonus + gun_sights_bonus


func _ready() -> void:
	data_load()


func data_save() -> void:
	var file := FileAccess.open("user://settings.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({
		game_speed = GameSpeed.find_key(game_speed),
		no_move = no_move,
		gun_sights = gun_sights,
		volume = volume,
		muted = muted,
	}))


func data_load() -> void:
	var file := FileAccess.open("user://settings.json", FileAccess.READ)
	if file == null:
		return
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	if not data.has("volume"):
		data.volume = 0.0
	if not data.has("muted"):
		data.muted = false
	game_speed = GameSpeed[data.game_speed]
	no_move = data.no_move
	gun_sights = data.gun_sights
	volume = data.volume
	muted = data.muted
