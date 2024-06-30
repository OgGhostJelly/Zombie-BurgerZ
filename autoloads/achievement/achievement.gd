extends Node


enum AchievementType {
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
	TenPierce,
	DontMove,
	Nihilism,
	DevSkins,
}


var data: Dictionary = {
	AchievementType.Kill10: {
		name = "Youre Hired",
		description = "kill 10 zombers in one run",
		texture = preload("res://assets/achievement_menu/achievements/youre_hired.svg"),
	},
	AchievementType.Kill50: {
		name = "Easy.",
		description = "kill 50 zombers in one run",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	},
	AchievementType.Kill100: {
		name = "Agent 47",
		description = "kill 100 zombers in one run",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	},
	AchievementType.TotalKill500: {
		name = "Jenny Side",
		description = "kill 500 zombers in total",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	},
	AchievementType.TotalKill1000: {
		name = "1000!",
		description = "kill 1000 zombers in total",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	},
	AchievementType.TotalKill10000: {
		name = "Agrostophobic",
		description = "kill 10000 zombers in total",
		texture = preload("res://assets/achievement_menu/achievements/agrostophobic.svg"),
	},
	
	AchievementType.Money100: {
		name = "Business Man in business land",
		description = "earn 100 money in total",
		texture = preload("res://assets/achievement_menu/achievements/business_man.svg")
	},
	AchievementType.Money1000: {
		name = "Soliciter",
		description = "earn 1000 money in total",
		texture = preload("res://assets/achievement_menu/achievements/business_man.svg")
	},
	AchievementType.Money10000: {
		name = "Microsoft",
		description = "earn 10000 money in total",
		texture = preload("res://assets/achievement_menu/achievements/business_man.svg")
	},
	
	AchievementType.EveryGun: {
		name = "Arms Dealer",
		description = "have every gun",
		texture = preload("res://assets/achievement_menu/achievements/arms_dealer.svg"),
	},
	AchievementType.EverySkin: {
		name = "People Person",
		description = "have every skin",
		texture = preload("res://assets/achievement_menu/achievements/people_person.svg"),
	},
	AchievementType.BuyEverything: {
		name = "Sold Out",
		description = "buy every item in the shop",
		texture = preload("res://assets/achievement_menu/achievements/sold_out.svg")
	},
	
	AchievementType.TripleKill: {
		name = "3 Birds 1 Stone",
		description = "kill three zombies with one bullet",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	},
	AchievementType.QuintuplePierce: {
		name = "Ready-Aim-Fire",
		description = "pierce five zombies with one bullet",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	},
	AchievementType.TenPierce: {
		name = "Tenetehara Pierce",
		description = "ten zombers. is this even possible?",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	},
	
	AchievementType.DontMove: {
		name = "Potato",
		description = "survive 60 seconds without moving",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	},
	AchievementType.Nihilism: {
		name = "nihilism",
		locked_name = "???",
		description = "it doesnt matter anyway",
		locked_description = "???",
		texture = preload("res://assets/achievement_menu/achievements/nihilism.svg"),
		locked_texture = preload("res://assets/achievement_menu/achievements/???.svg"),
	},
	
	AchievementType.DevSkins: {
		name = "Meet The Devs",
		description = "wait where did you get that?",
		texture = preload("res://assets/achievement_menu/achievements/dev_skin.svg"),
	}
}


signal gave_achievement(achievement: AchievementType)


func _ready() -> void:
	PlayerData.total_kills_changed.connect(func():
		if PlayerData.total_kills >= 500:
			give_achievement(AchievementType.TotalKill500)
		if PlayerData.total_kills >= 1000:
			give_achievement(AchievementType.TotalKill1000)
		if PlayerData.total_kills >= 10_000:
			give_achievement(AchievementType.TotalKill10000))
	
	PlayerData.total_money_changed.connect(func():
		if PlayerData.total_money >= 100:
			give_achievement(AchievementType.Money100)
		if PlayerData.total_money >= 1000:
			give_achievement(AchievementType.Money1000)
		if PlayerData.total_money >= 10_000:
			give_achievement(AchievementType.Money10000))
	
	PlayerData.owned_skins_changed.connect(func():
		check_every_skin()
		check_buy_everything()
		check_dev_skin())
	
	PlayerData.owned_guns_changed.connect(func():
		check_every_gun()
		check_buy_everything()
		check_dev_skin())
	
	gave_achievement.connect(func(_a):
		check_achievement_items())
	
	check_every_skin()
	check_every_gun()
	check_buy_everything()
	check_dev_skin()
	check_achievement_items()


func check_every_gun() -> void:
	if Gun.GunType.values().all(func(value): return PlayerData.owned_guns.has(value)):
		give_achievement(AchievementType.EveryGun)


func check_every_skin() -> void:
	if Player.PlayerType.values().all(func(value):
		if value == Player.PlayerType.OgGhostJelly or value == Player.PlayerType.SirF_:
			return true
		return PlayerData.has_skin(value)):
		give_achievement(AchievementType.EverySkin)


func check_buy_everything() -> void:
	if (
		Gun.GunType.values().all(func(value):
			if not Gun.gun_data[value].get("cost"):
				return true
			return PlayerData.has_gun(value)) and
		Player.PlayerType.values().all(func(value):
			if not Player.player_data[value].get("cost"):
				return true
			return PlayerData.has_skin(value))
	):
		give_achievement(AchievementType.BuyEverything)


func check_dev_skin() -> void:
	if not has_achievement(AchievementType.DevSkins):
		PlayerData.owned_skins.erase(Player.PlayerType.OgGhostJelly)
		PlayerData.owned_skins.erase(Player.PlayerType.SirF_)


func check_achievement_items() -> void:
	if has_achievement(AchievementType.TripleKill):
		PlayerData.try_add_gun(Gun.GunType.SniperRifle)
	
	if has_achievement(AchievementType.Nihilism):
		PlayerData.try_add_skin(Player.PlayerType.Blackhole)
	
	if has_achievement(AchievementType.DevSkins):
		PlayerData.try_add_skin(Player.PlayerType.OgGhostJelly)
		PlayerData.try_add_skin(Player.PlayerType.SirF_)


var level: Level = null
func _process(_delta: float) -> void:
	if is_instance_valid(level):
		return
	level = get_tree().current_scene as Level
	if level == null:
		return
	
	level.kill_count_changed.connect(func() -> void:
		if level.kill_count >= 10:
			give_achievement(AchievementType.Kill10)
		if level.kill_count >= 50:
			give_achievement(AchievementType.Kill50)
		if level.kill_count >= 100:
			give_achievement(AchievementType.Kill100))
	
	level.player.gun.fired.connect(func(bullets: Array[Node]) -> void:
		for node in bullets:
			var bullet: Bullet = node as Bullet
			if bullet == null:
				return
			
			bullet.checked_hit.connect(func(_a):
				var hits: int = bullets \
					.filter(func(v): return is_instance_valid(v)) \
					.reduce(func(a, b): return a + b.hits, 0)
				if hits >= 5:
					give_achievement(AchievementType.QuintuplePierce)
				if hits >= 10:
					give_achievement(AchievementType.TenPierce)
			)
			
			bullet.killed.connect(func(_a):
				var kills: int = bullets \
					.filter(func(v): return is_instance_valid(v)) \
					.reduce(func(a, b): return a + b.kills, 0)
				if kills >= 3:
					give_achievement(AchievementType.TripleKill)
			)
	)


func has_achievement(value: AchievementType) -> bool:
	return PlayerData.achievements.has(value)


func give_achievement(value: AchievementType) -> void:
	if has_achievement(value):
		return
	
	print(AchievementType.find_key(value))
	
	$AnimationPlayer.play("pop")
	PlayerData.achievements[value] = true
	PlayerData.data_save()
	gave_achievement.emit(value)
