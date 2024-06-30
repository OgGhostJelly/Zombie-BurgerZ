extends VBoxContainer

signal pressed


@onready var game_speed_100: CheckBox = %GameSpeed100
@onready var game_speed_120: CheckBox = %GameSpeed120
@onready var game_speed_150: CheckBox = %GameSpeed150
@onready var game_speed_200: CheckBox = %GameSpeed200


func _ready() -> void:
	game_speed_100.button_pressed = false
	game_speed_120.button_pressed = false
	game_speed_150.button_pressed = false
	game_speed_200.button_pressed = false
	
	match Settings.bonus_game_speed:
		0.0:
			game_speed_100.button_pressed = true
		0.2:
			game_speed_120.button_pressed = true
		0.5:
			game_speed_150.button_pressed = true
		1.0:
			game_speed_200.button_pressed = true


func uncheck_all() -> void:
	game_speed_100.button_pressed = false
	game_speed_120.button_pressed = false
	game_speed_150.button_pressed = false
	game_speed_200.button_pressed = false


func _on_game_speed_100_pressed() -> void:
	uncheck_all()
	game_speed_100.button_pressed = true
	Settings.bonus_game_speed = 0.0
	pressed.emit()


func _on_game_speed_120_pressed() -> void:
	uncheck_all()
	game_speed_120.button_pressed = true
	Settings.bonus_game_speed = 0.2
	pressed.emit()


func _on_game_speed_150_pressed() -> void:
	uncheck_all()
	game_speed_150.button_pressed = true
	Settings.bonus_game_speed = 0.5
	pressed.emit()


func _on_game_speed_200_pressed() -> void:
	uncheck_all()
	game_speed_200.button_pressed = true
	Settings.bonus_game_speed = 1.0
	pressed.emit()
