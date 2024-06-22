extends HBoxContainer

signal selected_changed


@onready var texture: TextureRect = $WeaponTexture
@onready var owned_label: Label = $WeaponTexture/OwnedLabel
@onready var price_label: Label = $WeaponTexture/PriceLabel
@onready var insufficient_funds_label: Label = $WeaponTexture/InsufficientFundsLabel
@onready var buy_button: Button = $WeaponTexture/BuyButton

var selected: Gun.GunType: set = set_selected


func _ready() -> void:
	selected = PlayerData.selected_gun


func _on_left_button_pressed() -> void:
	selected = wrapi(selected - 1, 0, Gun.GunType.size()) as Gun.GunType


func _on_right_button_pressed() -> void:
	selected = wrapi(selected + 1, 0, Gun.GunType.size()) as Gun.GunType


func _on_buy_button_pressed() -> void:
	if PlayerData.owned_guns.has(selected):
		return
	
	if PlayerData.money < Gun.gun_data[selected].cost:
		return
	
	PlayerData.owned_guns.append(selected)
	PlayerData.money -= Gun.gun_data[selected].cost
	PlayerData.data_save()
	selected = selected


func set_selected(value: Gun.GunType) -> void:
	selected = value
	texture.texture = Gun.gun_data[selected].texture
	
	owned_label.visible = false
	price_label.visible = false
	insufficient_funds_label.visible = false
	buy_button.visible = false
	
	if PlayerData.owned_guns.has(selected):
		owned_label.visible = true
		PlayerData.selected_gun = selected
	else:
		price_label.text = "$%s" % Gun.gun_data[selected].cost
		price_label.visible = true
		
		if PlayerData.money >= Gun.gun_data[selected].cost:
			buy_button.visible = true
		else:
			insufficient_funds_label.visible = true
	
	selected_changed.emit()
