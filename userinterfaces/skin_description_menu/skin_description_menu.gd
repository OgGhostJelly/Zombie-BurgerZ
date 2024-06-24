extends Control


@export var skin_menu: Control
@onready var label: Label = $Label


func _ready() -> void:
	skin_menu.selected_changed.connect(func():
		label.text = Player.player_data[skin_menu.selected].description)
	label.text = Player.player_data[skin_menu.selected].description
