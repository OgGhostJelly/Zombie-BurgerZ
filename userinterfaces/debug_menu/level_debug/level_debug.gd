extends Control


@onready var invulnerable: CheckBox = $Invulnerable
@onready var spawn_timer_label: Label = $SpawnTimerLabel
@export var spawn_timer: Timer
@export var player_path: NodePath
var player: Player


func _ready() -> void:
	player = get_node(player_path)
	visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		visible = not visible
	if invulnerable.button_pressed:
		player.invincibility_timer.start()
	
	spawn_timer_label.text = "Spawn: %.2f/%.2f" % [spawn_timer.time_left, spawn_timer.wait_time]
