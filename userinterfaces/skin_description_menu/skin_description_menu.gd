extends Control


@export var skin_menu: Control
@onready var label: Label = $Label
@onready var owned_label: Label = $OwnedLabel
@onready var buy_button: Button = $BuyButton
@onready var price_label: Label = $PriceLabel
@onready var insufficient_funds_label: Label = $InsufficientFundsLabel
@onready var locked_label: Label = $LockedLabel


func _ready() -> void:
	skin_menu.selected_changed.connect(_update)
	_update()


func _update() -> void:
	var selected: Player.PlayerType = skin_menu.selected
	label.text = Player.player_data[selected].description
	
	owned_label.visible = false
	price_label.visible = false
	insufficient_funds_label.visible = false
	buy_button.visible = false
	locked_label.visible = false
	
	if UserData.owned_skins.has(selected):
		owned_label.visible = true
		UserData.selected_skin = selected
	elif Player.player_data[selected].get("cost"):
		price_label.text = "$%s" % Player.player_data[selected].cost
		price_label.visible = true
		
		if UserData.money >= Player.player_data[selected].cost:
			buy_button.visible = true
		else:
			insufficient_funds_label.visible = true
	else:
		locked_label.visible = true


func _on_buy_button_pressed() -> void:
	var selected: Player.PlayerType = skin_menu.selected
	
	if UserData.has_skin(selected):
		return
	
	if UserData.money < Player.player_data[selected].cost:
		return
	
	UserData.money -= Player.player_data[selected].cost
	UserData.add_skin(selected)
	_update()
