extends Node


enum AcheivementType {
	Kill10,
	Kill50,
	Kill100,
	TotalKill500,
	TotalKill1000,
	TotalKill10000,
	Money100,
	Money1000,
	Money10000,
	EveryGun,
	EverySkin,
	BuyEverything,
	TripleKill,
	QuintuplePierce,
	DontMove,
	Nihilism,
}


var data: Dictionary = {
	AcheivementType.Kill10: {
		name = "Youre Hired",
		description = "kill 10 zombers in one run",
		texture = preload("res://assets/acheivement_menu/acheivements/youre_hired.svg"),
	},
	AcheivementType.Kill50: {
		name = "Easy.",
		description = "kill 50 zombers in one run",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	AcheivementType.Kill100: {
		name = "Agent 47",
		description = "kill 100 zombers in one run",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	AcheivementType.TotalKill500: {
		name = "Chara?",
		description = "kill 500 zombers in total",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	AcheivementType.TotalKill1000: {
		name = "1000!",
		description = "kill 1000 zombers in total",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	AcheivementType.TotalKill10000: {
		name = "Agrostophobic",
		description = "kill 10000 zombers in total",
		texture = preload("res://assets/acheivement_menu/acheivements/agrostophobic.svg"),
	},
	
	AcheivementType.Money100: {
		name = "Business Man in business land",
		description = "earn 100 money in total",
		texture = preload("res://assets/acheivement_menu/acheivements/business_man.svg")
	},
	AcheivementType.Money1000: {
		name = "Soliciter",
		description = "earn 1000 money in total",
		texture = preload("res://assets/acheivement_menu/acheivements/business_man.svg")
	},
	AcheivementType.Money10000: {
		name = "Microsoft",
		description = "earn 10000 money in total",
		texture = preload("res://assets/acheivement_menu/acheivements/business_man.svg")
	},
	
	AcheivementType.EveryGun: {
		name = "Arms Dealer",
		description = "have every gun",
		texture = preload("res://assets/acheivement_menu/acheivements/arms_dealer.svg"),
	},
	AcheivementType.EverySkin: {
		name = "People Person",
		description = "have every skin",
		texture = preload("res://assets/acheivement_menu/acheivements/people_person.svg"),
	},
	AcheivementType.BuyEverything: {
		name = "Sold Out",
		description = "buy every item in the shop",
		texture = preload("res://assets/acheivement_menu/acheivements/sold_out.svg")
	},
	
	AcheivementType.TripleKill: {
		name = "3 Birds 1 Stone",
		description = "kill three zombies with one bullet",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	AcheivementType.QuintuplePierce: {
		name = "Ready-Aim-Fire",
		description = "pierce five zombies with one shot",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	
	AcheivementType.DontMove: {
		name = "Potato",
		description = "last 60 seconds without moving",
		texture = preload("res://assets/acheivement_menu/acheivements/killer.svg"),
	},
	AcheivementType.Nihilism: {
		name = "nihilism",
		locked_name = "???",
		description = "it doesnt matter anyway",
		locked_description = "???",
		texture = preload("res://assets/acheivement_menu/acheivements/nihilism.svg"),
		locked_texture = preload("res://assets/acheivement_menu/acheivements/???.svg"),
	},
}


signal gave_acheivement(acheivement: AcheivementType)


func _ready() -> void:
	PlayerData.total_kills_changed.connect(func():
		if PlayerData.total_kills >= 500:
			give_acheivement(AcheivementType.TotalKill500)
		if PlayerData.total_kills >= 1000:
			give_acheivement(AcheivementType.TotalKill1000)
		if PlayerData.total_kills >= 10_000:
			give_acheivement(AcheivementType.TotalKill10000))
	
	PlayerData.total_money_changed.connect(func():
		if PlayerData.total_money >= 100:
			give_acheivement(AcheivementType.Money100)
		if PlayerData.total_money >= 1000:
			give_acheivement(AcheivementType.Money1000)
		if PlayerData.total_money >= 10_000:
			give_acheivement(AcheivementType.Money10000))


func _process(_delta: float) -> void:
	if Gun.GunType.values().all(func(value): return PlayerData.owned_guns.has(value)):
		give_acheivement(AcheivementType.EveryGun)
	
	if Player.PlayerType.values().all(func(value): return PlayerData.owned_skins.has(value)):
		give_acheivement(AcheivementType.EverySkin)
	
	if has_acheivement(AcheivementType.EveryGun) and has_acheivement(AcheivementType.EverySkin):
		give_acheivement(AcheivementType.BuyEverything)
	
	var level: Level = get_tree().current_scene as Level
	if level == null:
		return
	
	if level.kill_count >= 10:
		give_acheivement(AcheivementType.Kill10)
	if level.kill_count >= 50:
		give_acheivement(AcheivementType.Kill50)
	if level.kill_count >= 100:
		give_acheivement(AcheivementType.Kill100)
	
	for node in get_tree().get_nodes_in_group(&"bullets"):
		var bullet: Bullet = node as Bullet
		if bullet == null:
			return
		
		if bullet.kills >= 3:
			give_acheivement(AcheivementType.TripleKill)
		if bullet.hits >= 5:
			give_acheivement(AcheivementType.QuintuplePierce)


func has_acheivement(value: AcheivementType) -> bool:
	return PlayerData.acheivements.has(value)


func give_acheivement(value: AcheivementType) -> void:
	if has_acheivement(value):
		return
	
	$AnimationPlayer.play("pop")
	PlayerData.acheivements.append(value)
	PlayerData.data_save()
	gave_acheivement.emit(value)
