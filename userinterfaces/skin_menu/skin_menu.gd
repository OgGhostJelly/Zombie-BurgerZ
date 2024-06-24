extends HBoxContainer

signal selected_changed


@onready var texture: TextureRect = $WeaponTexture
@onready var owned_label: Label = $WeaponTexture/OwnedLabel
@onready var price_label: Label = $WeaponTexture/PriceLabel
@onready var insufficient_funds_label: Label = $WeaponTexture/InsufficientFundsLabel
@onready var buy_button: Button = $WeaponTexture/BuyButton

var selected: Player.PlayerType: set = set_selected


func _ready() -> void:
	selected = PlayerData.selected_skin


func _on_left_button_pressed() -> void:
	selected = wrapi(selected - 1, 0, Player.PlayerType.size()) as Player.PlayerType


func _on_right_button_pressed() -> void:
	selected = wrapi(selected + 1, 0, Player.PlayerType.size()) as Player.PlayerType


func _on_buy_button_pressed() -> void:
	if PlayerData.owned_skins.has(selected):
		return
	
	if PlayerData.money < Player.player_data[selected].cost:
		return
	
	PlayerData.owned_skins.append(selected)
	PlayerData.money -= Player.player_data[selected].cost
	PlayerData.data_save()
	selected = selected


func set_selected(value: Player.PlayerType) -> void:
	selected = value
	texture.texture = Player.player_data[selected].texture
	
	owned_label.visible = false
	price_label.visible = false
	insufficient_funds_label.visible = false
	buy_button.visible = false
	
	if PlayerData.owned_skins.has(selected):
		owned_label.visible = true
		PlayerData.selected_skin = selected
	else:
		price_label.text = "$%s" % Player.player_data[selected].cost
		price_label.visible = true
		
		if PlayerData.money >= Player.player_data[selected].cost:
			buy_button.visible = true
		else:
			insufficient_funds_label.visible = true
	
	selected_changed.emit()