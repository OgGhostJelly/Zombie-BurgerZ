extends HBoxContainer

signal selected_changed


@onready var texture: TextureRect = $WeaponTexture
@onready var owned_label: Label = $WeaponTexture/OwnedLabel
@onready var price_label: Label = $WeaponTexture/PriceLabel
@onready var insufficient_funds_label: Label = $WeaponTexture/InsufficientFundsLabel
@onready var buy_button: Button = $WeaponTexture/BuyButton
@onready var locked_label: Label = $WeaponTexture/LockedLabel
@onready var locked_description_label: Label = $WeaponTexture/LockedLabel/LockedDescriptionLabel

var selected: Gun.GunType: set = set_selected


func _ready() -> void:
	selected = UserData.selected_gun


func _on_left_button_pressed() -> void:
	selected = wrapi(selected - 1, 0, Gun.GunType.size()) as Gun.GunType


func _on_right_button_pressed() -> void:
	selected = wrapi(selected + 1, 0, Gun.GunType.size()) as Gun.GunType


func _on_buy_button_pressed() -> void:
	if UserData.has_gun(selected):
		return
	
	var gun: GunData = Gun.data[selected]
	var gun_cost: int = gun.get_cost()
	
	if UserData.money < gun_cost:
		return
	
	UserData.money -= gun_cost
	UserData.add_gun(selected)
	selected = selected


func set_selected(value: Gun.GunType) -> void:
	selected = value
	var gun: GunData = Gun.data[selected]
	texture.texture = gun.get_texture()
	
	owned_label.visible = false
	price_label.visible = false
	insufficient_funds_label.visible = false
	buy_button.visible = false
	locked_label.visible = false
	
	if UserData.owned_guns.has(selected):
		owned_label.visible = true
		UserData.selected_gun = selected
	elif gun.type == Data.Type.Purchaseable:
		var gun_cost: int = gun.get_cost()
		
		price_label.text = "$%s" % gun_cost
		price_label.visible = true
		
		if UserData.money >= gun_cost:
			buy_button.visible = true
		else:
			insufficient_funds_label.visible = true
	else:
		locked_label.visible = true
		locked_description_label.text = gun.get_locked_description()
	
	selected_changed.emit()
