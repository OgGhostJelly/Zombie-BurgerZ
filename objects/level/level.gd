extends Node2D


@export var enemy_supplier: PackedSceneSupplier

@onready var enemies: Node2D = $Enemies
@onready var spawn_path_follow: PathFollow2D = $SpawnPath/SpawnPathFollow

var kill_count: int = 0
var time: float = 0.0


func _ready() -> void:
	assert(enemy_supplier)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		$FrontLayer/Info.visible = not $FrontLayer/Info.visible
		$FrontLayer/PressU.visible = not $FrontLayer/Info.visible
	
	$FrontLayer/Time.text = "%.2f" % time
	if not $SpawnTimer.is_stopped():
		time += delta


func _on_spawn_timer_timeout() -> void:
	var enemy: PackedScene = enemy_supplier.supply()
	if enemy == null:
		return
	
	spawn_path_follow.progress_ratio = randf()
	
	var obj: Node2D = enemy.instantiate()
	obj.global_position = spawn_path_follow.global_position
	
	obj.died.connect(func():
		kill_count += 1
		$FrontLayer/KillCount.text = "%s/20" % kill_count)
	
	if not FileAccess.file_exists("user://thething.save") and kill_count == 15:
		var file: FileAccess = FileAccess.open("user://thething.save", FileAccess.WRITE)
		file.store_line('')
		obj.speed *= 4
	
	enemies.add_child(obj)


func _on_player_objective_ui_finished() -> void:
	$SpawnTimer.start()
