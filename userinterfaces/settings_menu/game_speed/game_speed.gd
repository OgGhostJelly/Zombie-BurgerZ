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
	
	match Challenge.game_speed:
		Challenge.GameSpeed.GameSpeed100:
			game_speed_100.button_pressed = true
		Challenge.GameSpeed.GameSpeed120:
			game_speed_120.button_pressed = true
		Challenge.GameSpeed.GameSpeed150:
			game_speed_150.button_pressed = true
		Challenge.GameSpeed.GameSpeed200:
			game_speed_200.button_pressed = true


func uncheck_all() -> void:
	game_speed_100.button_pressed = false
	game_speed_120.button_pressed = false
	game_speed_150.button_pressed = false
	game_speed_200.button_pressed = false


func _on_game_speed_100_pressed() -> void:
	uncheck_all()
	game_speed_100.button_pressed = true
	Challenge.game_speed = Challenge.GameSpeed.GameSpeed100
	pressed.emit()


func _on_game_speed_120_pressed() -> void:
	uncheck_all()
	game_speed_120.button_pressed = true
	Challenge.game_speed = Challenge.GameSpeed.GameSpeed120
	pressed.emit()


func _on_game_speed_150_pressed() -> void:
	uncheck_all()
	game_speed_150.button_pressed = true
	Challenge.game_speed = Challenge.GameSpeed.GameSpeed150
	pressed.emit()


func _on_game_speed_200_pressed() -> void:
	uncheck_all()
	game_speed_200.button_pressed = true
	Challenge.game_speed = Challenge.GameSpeed.GameSpeed200
	pressed.emit()
