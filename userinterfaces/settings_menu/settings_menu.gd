extends Control


@onready var no_moving: CheckBox = $Challenges/NoMoving/NoMoving
@onready var gun_sights: CheckBox = $Challenges/GunSights/GunSights


func _ready() -> void:
	no_moving.button_pressed = Settings.no_move
	gun_sights.button_pressed = Settings.gun_sights


func _on_no_moving_toggled(toggled_on: bool) -> void:
	Settings.no_move = toggled_on


func _on_gun_sights_toggled(toggled_on: bool) -> void:
	Settings.gun_sights = toggled_on


func _on_back_button_pressed() -> void:
	Settings.data_save()
