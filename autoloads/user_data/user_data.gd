extends Node

signal money_changed
signal total_kills_changed
signal total_money_changed
signal owned_guns_changed
signal owned_skins_changed


@export var money: int = 0: set = set_money
@export var total_money: int = 0: set = set_total_money
@export var selected_gun: Gun.GunType = Gun.GunType.Pistol
@export var selected_skin: Player.PlayerType = Player.PlayerType.Normal
@export var owned_guns: Dictionary = {Gun.GunType.Pistol:true}
@export var owned_skins: Dictionary = {Player.PlayerType.Normal:true}
@export var achievements: Dictionary = {}
@export var total_kills: int = 0: set = set_total_kills

@export var main_menu_seen: bool = false
@export var achievement_menu_seen: bool = false
var version: int


func _ready() -> void:
	data_load()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		data_save()


func try_add_skin(skin: Player.PlayerType) -> void:
	if not has_skin(skin):
		add_skin(skin)


func add_skin(skin: Player.PlayerType) -> void:
	owned_skins[skin] = true
	data_save()
	owned_skins_changed.emit()


func has_skin(skin: Player.PlayerType) -> bool:
	return owned_skins.has(skin)


func try_add_gun(gun: Gun.GunType) -> void:
	if not has_gun(gun):
		add_gun(gun)


func add_gun(gun: Gun.GunType) -> void:
	owned_guns[gun] = true
	data_save()
	owned_guns_changed.emit()


func has_gun(gun: Gun.GunType) -> bool:
	return owned_guns.has(gun)


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
	create_backup()
	var file := FileAccess.open("user://save.dat", FileAccess.WRITE)
	save_to_file(file)


func create_backup() -> void:
	DirAccess.open("user://").rename("save.bak.dat", "save.bak2.dat")
	DirAccess.open("user://").rename("save.dat", "save.bak.dat")


func save_to_file(file: FileAccess) -> void:
	file.store_string(save_as_string())


func save_as_string() -> String:
	return JSON.stringify({
		money = money,
		total_money = total_money,
		selected_gun = Gun.GunType.find_key(selected_gun),
		owned_guns = owned_guns.keys().map(func(value): return Gun.GunType.find_key(value)),
		selected_skin = Player.PlayerType.find_key(selected_skin),
		owned_skins = owned_skins.keys().map(func(value): return Player.PlayerType.find_key(value)),
		achievements = achievements.keys(),
		total_kills = total_kills,
		version = version,
	})


func data_load() -> void:
	if FileAccess.file_exists("user://save"):
		old_data_load()
		data_save()
		DirAccess.open("user://").remove("save")
		return
	
	var file := FileAccess.open("user://save.dat", FileAccess.READ)
	if file == null:
		return
	load_from_file(file)


func load_from_file(file: FileAccess) -> void:
	load_from_string(file.get_as_text())

func load_from_string(string: String) -> void:
	var ret = JSON.parse_string(string)
	if ret == null:
		push_warning("Failed to import data")
		return
	var data: Dictionary = ret
	
	if not data.has("version"):
		data.version = 1
	if not data.has("total_money"):
		data.total_money = 0
	if not data.has("game_speed"):
		data.game_speed = 1.0
	
	if not data.selected_gun is String:
		data.selected_gun = Gun.GunType.keys()[data.selected_gun]
	if not data.selected_skin is String:
		data.selected_skin = Player.PlayerType.keys()[data.selected_skin]
	
	if not data.has("achievements"):
		push_warning("Failed to import data")
		return
	if not data.has("owned_guns"):
		push_warning("Failed to import data")
		return
	if not data.has("owned_skins"):
		push_warning("Failed to import data")
		return
	if not data.has("money"):
		push_warning("Failed to import data")
		return
	if not data.has("total_money"):
		push_warning("Failed to import data")
		return
	if not data.has("selected_gun"):
		push_warning("Failed to import data")
		return
	if not data.has("selected_skin"):
		push_warning("Failed to import data")
		return
	if not data.has("total_kills"):
		push_warning("Failed to import data")
		return
	if not data.has("version"):
		push_warning("Failed to import data")
		return
	
	achievements.clear()
	for achievement in data.achievements:
		achievements[achievement] = true
	
	owned_guns.clear()
	for gun in data.owned_guns:
		owned_guns[Gun.GunType[gun]] = true
	
	owned_skins.clear()
	for skin in data.owned_skins:
		owned_skins[Player.PlayerType[skin]] = true
	
	money = data.money
	total_money = data.total_money
	selected_gun = Gun.GunType[data.selected_gun]
	selected_skin = Player.PlayerType[data.selected_skin]
	total_kills = data.total_kills
	version = data.version


func old_data_load() -> void:
	var data := FileAccess.open("user://save", FileAccess.READ)
	
	if data == null:
		return
	
	money = data.get_64()
	selected_gun = data.get_64() as Gun.GunType
	owned_guns = data.get_var()
	selected_skin = data.get_64() as Player.PlayerType
	owned_skins = data.get_var()
	achievements = data.get_var()
	total_kills = data.get_64()


func _on_auto_save_timer_timeout() -> void:
	data_save()
