extends Control


@onready var no_moving: CheckBox = $Challenges/NoMoving/NoMoving
@onready var gun_sights: CheckBox = $Challenges/GunSights/GunSights


func _ready() -> void:
	no_moving.button_pressed = Challenge.no_move
	gun_sights.button_pressed = Challenge.gun_sights


func _on_no_moving_toggled(toggled_on: bool) -> void:
	Challenge.no_move = toggled_on


func _on_gun_sights_toggled(toggled_on: bool) -> void:
	Challenge.gun_sights = toggled_on


func _on_back_button_pressed() -> void:
	Challenge.data_save()
