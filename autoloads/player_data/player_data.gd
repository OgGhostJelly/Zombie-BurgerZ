extends Node

signal money_changed


@export var money: int = 0: set = set_money
@export var selected_gun: Gun.GunType = Gun.GunType.Pistol
@export var selected_skin: Player.PlayerType = Player.PlayerType.Normal
@export var owned_guns: Array = [Gun.GunType.Pistol]
@export var owned_skins: Array = [Player.PlayerType.Normal]


func _ready() -> void:
	data_load()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		data_save()


func set_money(value: int) -> void:
	money = value
	money_changed.emit()


func data_save() -> void:
	var data := FileAccess.open("user://save", FileAccess.WRITE)
	data.store_64(money)
	
	data.store_64(selected_gun)
	data.store_var(owned_guns)
	
	data.store_64(selected_skin)
	data.store_var(owned_skins)


func data_load() -> void:
	var data := FileAccess.open("user://save", FileAccess.READ)
	
	if data == null:
		return
	
	money = data.get_64()
	
	selected_gun = data.get_64() as Gun.GunType
	owned_guns = data.get_var()
	
	selected_skin = data.get_64() as Player.PlayerType
	owned_skins = data.get_var()

func _on_auto_save_timer_timeout() -> void:
	data_save()
