extends Control


@onready var invulnerable: CheckBox = $Invulnerable
@onready var instant_reload: CheckBox = $InstantReload
@onready var infinite_ammo: CheckBox = $InfiniteAmmo
@onready var spawn_time: SpinBox = $SpawnTime
@onready var spawn_timer_label: Label = $SpawnTimerLabel
@export var spawn_timer: Timer
@export var player_path: NodePath
var player: Player


func _ready() -> void:
	visible = false
	player = get_node(player_path)
	invulnerable.button_pressed = not player.invincibility_timer.one_shot


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		visible = not visible
	if infinite_ammo.button_pressed:
		player.gun.ammo.value = player.gun.ammo.max_value
	if instant_reload.button_pressed:
		player.gun.animation_player.stop()
	
	spawn_time.value = spawn_timer.wait_time
	
	spawn_timer_label.text = "Next Spawn %.2f/%.2f" % [spawn_timer.time_left, spawn_timer.wait_time]


func _on_invulnerable_toggled(toggled_on: bool) -> void:
	player.invincibility_timer.one_shot = not toggled_on
	if toggled_on:
		player.invincibility_timer.start()
	else:
		player.invincibility_timer.stop()


func _on_give_health_pressed() -> void:
	player.health.value += 1


func _on_spawn_time_value_changed(value: float) -> void:
	spawn_timer.wait_time = value
