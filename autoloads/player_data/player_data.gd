extends Node

signal money_changed
signal total_kills_changed
signal total_money_changed


@export var money: int = 0: set = set_money
@export var total_money: int = 0: set = set_total_money
@export var selected_gun: Gun.GunType = Gun.GunType.Pistol
@export var selected_skin: Player.PlayerType = Player.PlayerType.Normal
@export var owned_guns: Array = [Gun.GunType.Pistol]
@export var owned_skins: Array = [Player.PlayerType.Normal]
@export var acheivements: Array = []
@export var total_kills: int = 0: set = set_total_kills


func _ready() -> void:
	data_load()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		data_save()


func set_money(value: int) -> void:
	if value - money > 0:
		total_money += value - money
	money = value
	money_changed.emit()


func set_total_money(value: int) -> void:
	total_money = value
	total_money_changed.emit()


func set_total_kills(value: int) -> void:
	total_kills = value
	total_kills_changed.emit()


func data_save() -> void:
	var data := FileAccess.open("user://save", FileAccess.WRITE)
	data.store_64(money)
	
	data.store_64(selected_gun)
	data.store_var(owned_guns)
	
	data.store_64(selected_skin)
	data.store_var(owned_skins)
	
	data.store_var(acheivements)
	
	data.store_64(total_kills)


func data_load() -> void:
	var data := FileAccess.open("user://save", FileAccess.READ)
	
	if data == null:
		return
	
	money = data.get_64()
	
	selected_gun = data.get_64() as Gun.GunType
	owned_guns = data.get_var()
	
	selected_skin = data.get_64() as Player.PlayerType
	owned_skins = data.get_var()
	
	acheivements = data.get_var()
	
	total_kills = data.get_64()

func _on_auto_save_timer_timeout() -> void:
	data_save()
