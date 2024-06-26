extends Control
class_name MainMenu


@onready var entrance_animation: AnimationPlayer = $Sign/Sign/EntranceAnimation
@onready var bop_animation: AnimationPlayer = $Sign/Sign/BopAnimation


func _ready() -> void:
	if PlayerData.main_menu_seen:
		entrance_animation.stop()
		bop_animation.play(&"bop")
		return
	PlayerData.main_menu_seen = true
