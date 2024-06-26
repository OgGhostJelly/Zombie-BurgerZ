extends Control


@export var weapon_menu: Control
@export var skin_menu: Control

@onready var buy_bypass: CheckBox = $BuyBuypass


func _ready() -> void:
	visible = false
	
	weapon_menu.selected_changed.connect(func():
		if not buy_bypass.button_pressed:
			return
		PlayerData.selected_gun = weapon_menu.selected)
	skin_menu.selected_changed.connect(func():
		if not buy_bypass.button_pressed:
			return
		PlayerData.selected_skin = skin_menu.selected)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		visible = not visible
