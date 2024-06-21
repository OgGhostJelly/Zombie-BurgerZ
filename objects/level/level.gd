extends Node2D


@export var enemy_supplier: PackedSceneSupplier

@onready var enemies: Node2D = $Enemies
@onready var spawn_path_follow: PathFollow2D = $SpawnPath/SpawnPathFollow
@onready var player: Player = $Player
@onready var grace_period_timer: Timer = $GracePeriodTimer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var time_label: Label = $FrontLayer/Time
@onready var kill_count_label: Label = $FrontLayer/KillCount
@onready var game_over_menu: Control = $FrontLayer/GameOverMenu

var initial_money: int = 0
var kill_count: int = 0
var time: float = 0.0


func _ready() -> void:
	assert(enemy_supplier)
	
	initial_money = PlayerData.money
	
	grace_period_timer.timeout.connect(func():
		spawn_timer.paused = false)
	
	player.health.value_changed.connect(func():
		grace_period_timer.start()
		spawn_timer.paused = true)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		$FrontLayer/DebugInfo.visible = not $FrontLayer/DebugInfo.visible
	
	if not spawn_timer.is_stopped():
		time += delta
		time_label.text = "%.2fs" % time


func _on_spawn_timer_timeout() -> void:
	var enemy: PackedScene = enemy_supplier.supply()
	if enemy == null:
		return
	
	spawn_path_follow.progress_ratio = randf()
	
	var obj: Node2D = enemy.instantiate()
	obj.global_position = spawn_path_follow.global_position
	
	obj.died.connect(func():
		kill_count += 1
		kill_count_label.text = "%s/20" % kill_count)
	
	if not FileAccess.file_exists("user://thething.save") and kill_count == 15:
		var file: FileAccess = FileAccess.open("user://thething.save", FileAccess.WRITE)
		file.store_line('')
		obj.speed *= 4
	
	enemies.add_child(obj)


func _on_player_objective_ui_finished() -> void:
	spawn_timer.start()


func _on_player_died() -> void:
	game_over_menu.game_over(time, PlayerData.money - initial_money, kill_count)
