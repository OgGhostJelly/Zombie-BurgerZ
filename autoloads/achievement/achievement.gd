extends Node


signal gave_achievement(achievement: StringName)

var data: Dictionary = {}

func register_kill_achievement(p_name: String, kills: int, texture: Texture2D = null):
	register_achievement("Kill" + str(kills), AchievementData.create({
		name = p_name,
		description = "kill %s zombers in one run" % kills,
		texture = texture if texture != null else preload("res://assets/achievement_menu/achievements/killer.svg")
	}))

func register_total_kill_achievement(p_name: String, kills: int, texture: Texture2D = null):
	var id: StringName = "TotalKill" + str(kills)
	
	register_achievement(id, AchievementData.create({
		name = p_name,
		description = "kill %s zombers in total" % kills,
		texture = texture if texture != null else preload("res://assets/achievement_menu/achievements/killer.svg")
	}))
	
	UserData.total_kills_changed.connect(func():
		if UserData.total_kills >= kills:
			give_achievement(id))

func register_total_money_achievement(p_name: String, money: int, texture: Texture2D = null):
	var id: StringName = "Money" + str(money)
	
	register_achievement(id, AchievementData.create({
		name = p_name,
		description = "earn %s money in total" % money,
		texture = texture if texture != null else preload("res://assets/achievement_menu/achievements/deal.svg")
	}))
	
	UserData.total_money_changed.connect(func():
		if UserData.total_money >= money:
			give_achievement(id))

func register_achievement(id: StringName, p_data: AchievementData) -> void:
	data[id] = p_data

const EVERY_GUN: StringName = &"EveryGun"
const EVERY_SKIN: StringName = &"EverySkin"
const BUY_EVERYTHING: StringName = &"BuyEverything"
const ONESHOT_KILL_3: StringName = &"TripleKill"
const ONESHOT_PIERCE_5: StringName = &"QuintuplePierce"
const ONESHOT_PIERCE_10: StringName = &"TenPierce"
const NO_MOVING: StringName = &"DontMove"
const NIHILISM: StringName = &"Nihilism"
const EVERY_DEV_SKIN: StringName = &"DevSkins"

func _ready() -> void:
	register_kill_achievement("Youre Hired", 10, preload("res://assets/achievement_menu/achievements/youre_hired.svg"))
	register_kill_achievement("Easy.", 50)
	register_kill_achievement("Agent 47", 100)
	
	register_total_kill_achievement("Jenny Side", 500)
	register_total_kill_achievement("1000!", 1000)
	register_total_kill_achievement("Agrostophobic", 10_000, preload("res://assets/achievement_menu/achievements/agrostophobic.svg"))
	
	register_total_money_achievement("Business Man in business land", 100)
	register_total_money_achievement("Soliciter", 1000)
	register_total_money_achievement("Microsoft", 10_000)
	
	register_achievement(EVERY_GUN, AchievementData.create({
		name = "Arms Dealer",
		description = "have every gun",
		texture = preload("res://assets/achievement_menu/achievements/arms_dealer.svg"),
	}))
	register_achievement(EVERY_SKIN, AchievementData.create({
		name = "People Person",
		description = "have every skin",
		texture = preload("res://assets/achievement_menu/achievements/people_person.svg"),
	}))
	register_achievement(BUY_EVERYTHING, AchievementData.create({
		name = "Sold Out",
		description = "buy every item in the shop",
		texture = preload("res://assets/achievement_menu/achievements/sold_out.svg"),
	}))
	
	register_achievement(ONESHOT_KILL_3, AchievementData.create({
		name = "3 Birds 1 Stone",
		description = "kill three zombies with one bullet",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	}))
	
	register_achievement(ONESHOT_PIERCE_5, AchievementData.create({
		name = "Ready-Aim-Fire",
		description = "pierce five zombies with one bullet",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	}))
	register_achievement(ONESHOT_PIERCE_10, AchievementData.create({
		name = "Tenetehara Pierce",
		description = "ten zombers. is this even possible?",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	}))
	
	register_achievement(NO_MOVING, AchievementData.create({
		name = "Potato",
		description = "survive 120 seconds with 'no moving'",
		texture = preload("res://assets/achievement_menu/achievements/killer.svg"),
	}))
	
	register_achievement(NIHILISM, AchievementData.create({
		name = "nihilism",
		locked_name = "???",
		description = "it doesnt matter anyway",
		locked_description = "???",
		texture = preload("res://assets/achievement_menu/achievements/nihilism.svg"),
		locked_texture = preload("res://assets/achievement_menu/achievements/unknown.svg"),
		type = AchievementData.Type.Lockable,
	}))
	
	register_achievement(EVERY_DEV_SKIN, AchievementData.create({
		name = "Meet The Devs",
		description = "wait where did you get that?",
		texture = preload("res://assets/achievement_menu/achievements/dev_skin.svg"),
	}))
	
	UserData.owned_skins_changed.connect(func():
		check_every_skin()
		check_buy_everything()
		check_dev_skin())
	
	UserData.owned_guns_changed.connect(func():
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
	if Gun.GunType.values().all(func(value): return UserData.owned_guns.has(value)):
		give_achievement(EVERY_GUN)


func check_every_skin() -> void:
	if Player.PlayerType.values().all(func(value):
		if value == Player.PlayerType.OgGhostJelly or value == Player.PlayerType.SirF_:
			return true
		return UserData.has_skin(value)):
		give_achievement(EVERY_SKIN)


func check_buy_everything() -> void:
	if (
		Gun.GunType.values().all(func(value):
			if Gun.data[value].type != GunData.Type.Purchaseable:
				return true
			return UserData.has_gun(value)) and
		Player.PlayerType.values().all(func(value):
			if Player.data[value].type != PlayerData.Type.Purchaseable:
				return true
			return UserData.has_skin(value))
	):
		give_achievement(BUY_EVERYTHING)


func check_dev_skin() -> void:
	if not has_achievement(EVERY_DEV_SKIN):
		UserData.owned_skins.erase(Player.PlayerType.OgGhostJelly)
		UserData.owned_skins.erase(Player.PlayerType.SirF_)


func check_achievement_items() -> void:
	if has_achievement(ONESHOT_KILL_3):
		UserData.try_add_gun(Gun.GunType.SniperRifle)
	
	if has_achievement(NIHILISM):
		UserData.try_add_skin(Player.PlayerType.Blackhole)
	
	if has_achievement(EVERY_DEV_SKIN):
		UserData.try_add_skin(Player.PlayerType.OgGhostJelly)
		UserData.try_add_skin(Player.PlayerType.SirF_)


var level: Level = null
func _process(_delta: float) -> void:
	if is_instance_valid(level):
		return
	level = get_tree().current_scene as Level
	if level == null:
		return
	
	level.kill_count_changed.connect(func() -> void:
		if level.kill_count >= 10:
			give_achievement(&"Kill10")
		if level.kill_count >= 50:
			give_achievement(&"Kill50")
		if level.kill_count >= 100:
			give_achievement(&"Kill100"))
	
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
					give_achievement(ONESHOT_PIERCE_5)
				if hits >= 10:
					give_achievement(ONESHOT_PIERCE_10)
			)
			
			bullet.killed.connect(func(_a):
				var kills: int = bullets \
					.filter(func(v): return is_instance_valid(v)) \
					.reduce(func(a, b): return a + b.kills, 0)
				if kills >= 3:
					give_achievement(ONESHOT_KILL_3)
			)
	)


func has_achievement(value: StringName) -> bool:
	return UserData.achievements.has(value)


func give_achievement(value: StringName) -> void:
	if has_achievement(value):
		return
	
	$AnimationPlayer.play("pop")
	UserData.achievements[value] = true
	UserData.data_save()
	gave_achievement.emit(value)
