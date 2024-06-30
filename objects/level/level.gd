extends Node2D
class_name Level

signal kill_count_changed



@export var enemy_scenes: Array[PackedScene] = []

@onready var enemies: Node2D = $Enemies
@onready var spawn_path_follow: PathFollow2D = $SpawnPath/SpawnPathFollow
@onready var player: Player = $Player
@onready var grace_period_timer: Timer = $GracePeriodTimer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var time_label: Label = $FrontLayer/Time/TimeLabel
@onready var kill_count_label: Label = $FrontLayer/KillCount/KillCountLabel
@onready var game_over_menu: Control = $FrontLayer/GameOverMenu
@onready var next_spawn: Node2D = get_next_spawn()


var initial_money: int = 0
var kill_count: int = 0:
	set(v):
		kill_count = v
		kill_count_changed.emit()
var time: float = 0.0
var wave: int = 0
var kill_count_req: int = 20
var has_moved: bool = false
var has_fired: bool = false
var has_indicator: bool = false


func _init() -> void:
	var obj: Player = Player.player_data[PlayerData.selected_skin].scene.instantiate()
	obj.global_position = Vector2(480.0, 360.0) / 2.0
	obj.name = "Player"
	add_child(obj)


func _ready() -> void:
	assert(enemy_scenes)
	assert(player)
	
	player.died.connect(_on_player_died)
	
	initial_money = PlayerData.money
	
	grace_period_timer.timeout.connect(func():
		spawn_timer.paused = false)
	
	player.health.value_changed.connect(func():
		grace_period_timer.start()
		spawn_timer.paused = true)
	
	Engine.time_scale = 1.0 + Settings.bonus_game_speed


func _process(delta: float) -> void:
	if not spawn_timer.is_stopped():
		time += delta
		time_label.text = "%.2fs" % time
	
	if time >= 60.0 and not has_moved:
		Achievement.give_achievement(Achievement.AchievementType.DontMove)
	
	if not spawn_timer.is_stopped() and spawn_timer.time_left <= 0.5 and not has_indicator:
		var indicator: Node2D = preload("res://objects/enemy_indicator/enemy_indicator.tscn").instantiate()
		indicator.global_position = next_spawn.global_position
		add_child(indicator)
		has_indicator = true


func _on_spawn_timer_timeout() -> void:
	enemies.add_child(next_spawn)
	next_spawn = get_next_spawn()
	has_indicator = false


func get_next_spawn() -> Node2D:
	var enemy: PackedScene = enemy_scenes.slice(0, wave + 1).pick_random()
	if enemy == null:
		return
	
	spawn_path_follow.progress_ratio = randf()
	
	var obj: Node2D = enemy.instantiate()
	obj.global_position = spawn_path_follow.global_position
	
	obj.died.connect(func():
		kill_count += 1
		PlayerData.total_kills += 1
		
		if kill_count >= kill_count_req:
			for i in range(int(kill_count_req / 2.0)):
				var money: Node2D = preload("res://objects/pickup/money_pickup.tscn").instantiate()
				money.global_position = player.global_position
				money.cooldown_time = 0.5
				call_deferred(&"add_child", money)
			
			kill_count_req *= 2
			wave = mini(wave + 1, enemy_scenes.size() - 1)
			if wave >= enemy_scenes.size() - 1:
				spawn_timer.wait_time *= 0.9
		
		kill_count_label.text = "%s/%s" % [kill_count, kill_count_req])
	
	if not FileAccess.file_exists("user://veryimportantgamerfile") and kill_count == 15:
		var file: FileAccess = FileAccess.open("user://veryimportantgamerfile", FileAccess.WRITE)
		file.store_line('')
		obj.speed *= 4
	
	return obj


func _on_player_objective_ui_finished() -> void:
	spawn_timer.start()
	spawn_timer.timeout.connect(func():
		player.moved.connect(func():
			has_moved = true)
		player.gun.fired.connect(func(_a):
			has_fired = true)
		, CONNECT_ONE_SHOT)


func _on_player_died() -> void:
	if time >= 30.0 and not has_fired:
		Achievement.give_achievement(Achievement.AchievementType.Nihilism)
	game_over_menu.game_over(time, PlayerData.money - initial_money, kill_count)
