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
	var data: PlayerData = Player.data[selected]
	label.text = data.get_description()
	
	owned_label.visible = false
	price_label.visible = false
	insufficient_funds_label.visible = false
	buy_button.visible = false
	locked_label.visible = false
	
	if UserData.owned_skins.has(selected):
		owned_label.visible = true
		UserData.selected_skin = selected
	elif data.type == Data.Type.Purchaseable:
		var player_cost: int = data.get_cost()
		price_label.text = "$%s" % player_cost
		price_label.visible = true
		
		if UserData.money >= player_cost:
			buy_button.visible = true
		else:
			insufficient_funds_label.visible = true
	else:
		locked_label.visible = true


func _on_buy_button_pressed() -> void:
	var selected: Player.PlayerType = skin_menu.selected
	
	if UserData.has_skin(selected):
		return
	
	var data: PlayerData = Player.data[selected]
	var player_cost: int = data.get_cost()
	
	if UserData.money < player_cost:
		return
	
	UserData.money -= player_cost
	UserData.add_skin(selected)
	_update()
