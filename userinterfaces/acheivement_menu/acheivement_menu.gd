extends Control


var acheivements: Array[Dictionary] = [
	{
		name = "Youre Hired",
		description = "kill 10 zombers in one run",
		texture = preload("res://assets/acheivement_menu/acheivements/youre_hired.svg"),
	},
	{
		name = "Easy.",
		description = "kill 50 zombers in one run",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	{
		name = "Agent 47",
		description = "kill 100 zombers in one run",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	{
		name = "Chara?",
		description = "kill 500 zombers in total",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	{
		name = "1000!",
		description = "kill 1000 zombers in total",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	{
		name = "Agrostophobic",
		description = "kill 10000 zombers in total",
		texture = preload("res://assets/acheivement_menu/acheivements/agrostophobic.svg"),
	},
	
	{
		name = "Arms Dealer",
		description = "have every gun",
		texture = preload("res://assets/acheivement_menu/acheivements/arms_dealer.svg"),
	},
	{
		name = "People Person",
		description = "have every skin",
		texture = preload("res://assets/acheivement_menu/acheivements/people_person.svg"),
	},
	
	{
		name = "3 Birds 1 Stone",
		description = "kill three zombies with one bullet",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	{
		name = "Aim-Fire",
		description = "pierce five zombies with one shot",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	{
		name = "nihilism",
		locked_name = "???",
		description = "it doesnt matter anyway",
		locked_description = "???",
		texture = preload("res://assets/acheivement_menu/acheivements/nihilism.svg"),
		locked_texture = preload("res://assets/acheivement_menu/acheivements/???.svg"),
	},
]


@onready var sign_texture: TextureRect = $Sign/Sign
@onready var title_label: Label = $Sign/Sign/TitleLabel
@onready var description_label: Label = $Sign/Sign/DescriptionLabel

var selected: int = 0: set = set_selected


func _ready() -> void:
	selected = selected


func set_selected(value: int) -> void:
	selected = wrapi(value, 0, acheivements.size())
	
	title_label.text = (
		acheivements[selected].locked_name
		if acheivements[selected].get("locked_name") else
		acheivements[selected].name
	)
	description_label.text = (
		acheivements[selected].locked_description
		if acheivements[selected].get("locked_description") else
		acheivements[selected].description
	)
	
	if PlayerData.acheivements.has(selected):
		sign_texture.texture = acheivements[selected].texture
	else:
		sign_texture.texture = (
			acheivements[selected].locked_texture
			if acheivements[selected].get("locked_texture") else
			preload("res://assets/acheivement_menu/locked.svg")
		)


func _on_left_button_pressed() -> void:
	selected -= 1
func _on_right_button_pressed() -> void:
	selected += 1
