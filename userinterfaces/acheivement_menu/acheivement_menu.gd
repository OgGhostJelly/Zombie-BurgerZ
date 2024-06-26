extends Control
class_name AcheivementMenu


@onready var sign_texture: TextureRect = $Sign/Sign
@onready var title_label: Label = $Sign/Sign/TitleLabel
@onready var description_label: Label = $Sign/Sign/DescriptionLabel
@onready var entrance_animation: AnimationPlayer = $Sign/Sign/EntranceAnimation
@onready var bop_animation: AnimationPlayer = $Sign/Sign/BopAnimation

var selected: int = 0: set = set_selected


func _ready() -> void:
	selected = selected
	
	if PlayerData.acheivement_menu_seen:
		entrance_animation.stop()
		bop_animation.play(&"bop")
		return
	PlayerData.acheivement_menu_seen = true


func set_selected(value: int) -> void:
	selected = wrapi(value, 0, Acheivement.data.size())
	
	var owned: bool = PlayerData.acheivements.has(selected)
	
	title_label.text = (
		Acheivement.data[selected].locked_name
		if Acheivement.data[selected].get("locked_name") and not owned else
		Acheivement.data[selected].name
	)
	description_label.text = (
		Acheivement.data[selected].locked_description
		if Acheivement.data[selected].get("locked_description") and not owned else
		Acheivement.data[selected].description
	)
	
	if owned:
		sign_texture.texture = Acheivement.data[selected].texture
	else:
		sign_texture.texture = (
			Acheivement.data[selected].locked_texture
			if Acheivement.data[selected].get("locked_texture") else
			preload("res://assets/acheivement_menu/locked.svg")
		)


func _on_left_button_pressed() -> void:
	selected -= 1
func _on_right_button_pressed() -> void:
	selected += 1
