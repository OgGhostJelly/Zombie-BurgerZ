extends Control
class_name AchievementMenu


@onready var sign_texture: TextureRect = $Sign/Sign
@onready var title_label: Label = $Sign/Sign/TitleLabel
@onready var description_label: Label = $Sign/Sign/DescriptionLabel
@onready var entrance_animation: AnimationPlayer = $Sign/Sign/EntranceAnimation
@onready var bop_animation: AnimationPlayer = $Sign/Sign/BopAnimation

var selected: int = 0: set = set_selected


func _ready() -> void:
	selected = selected
	
	if PlayerData.achievement_menu_seen:
		entrance_animation.stop()
		bop_animation.play(&"bop")
		return
	PlayerData.achievement_menu_seen = true


func set_selected(value: int) -> void:
	selected = wrapi(value, 0, Achievement.data.size())
	
	var owned: bool = PlayerData.achievements.has(selected)
	
	title_label.text = (
		Achievement.data[selected].locked_name
		if Achievement.data[selected].get("locked_name") and not owned else
		Achievement.data[selected].name
	)
	description_label.text = (
		Achievement.data[selected].locked_description
		if Achievement.data[selected].get("locked_description") and not owned else
		Achievement.data[selected].description
	)
	
	if owned:
		sign_texture.texture = Achievement.data[selected].texture
	else:
		sign_texture.texture = (
			Achievement.data[selected].locked_texture
			if Achievement.data[selected].get("locked_texture") else
			preload("res://assets/achievement_menu/locked.svg")
		)


func _on_left_button_pressed() -> void:
	selected -= 1
func _on_right_button_pressed() -> void:
	selected += 1
