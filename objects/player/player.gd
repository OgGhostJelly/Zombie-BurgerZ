extends Character2D
class_name Player

signal moved

static var data: Dictionary = {
	PlayerType.Normal: load("res://resources/PlayerData/normal.tres"),
	PlayerType.Dash: load("res://resources/PlayerData/dash.tres"),
	PlayerType.Trapper: load("res://resources/PlayerData/trapper.tres"),
	PlayerType.Blackhole: load("res://resources/PlayerData/blackhole.tres"),
	PlayerType.OgGhostJelly: load("res://resources/PlayerData/ogghostjelly.tres"),
	PlayerType.SirF_:  load("res://resources/PlayerData/sirf_.tres"),
}

enum PlayerType {
	Normal,
	Dash,
	Trapper,
	Blackhole,
	OgGhostJelly,
	SirF_,
}

@export var speed: float = 120.0
@export var acceleration: float = 600.0
@export var deceleration: float = 400.0
@export var knockback_enabled: bool = true

@onready var gun: Gun = $Gun
@onready var health_ui: Control = $HealthUI
@onready var ammo_ui: Control = $AmmoUI
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var damage_audio: AudioStreamPlayer = $DamageAudio
@onready var energy_bar: EnergyBar = $EnergyBar
@onready var hitbox: Area2D = $HitDetector
@onready var blur_effect: ColorRect = $CanvasLayer/BlurEffect
@onready var heartbeat_audio: AudioStreamPlayer = $HeartbeatAudio
@onready var ringing_audio: AudioStreamPlayer = $RingingAudio
@onready var heartbeat_timer: Timer = $HeartbeatTimer

static var player: Player


func _init() -> void:
	if scene_file_path:
		return
	
	var obj: Gun = Gun.data[UserData.selected_gun].get_scene().instantiate()
	obj.name = "Gun"
	add_child(obj)


func _ready() -> void:
	super()
	player = self
	
	tree_exiting.connect(func():
		AudioServer.set_bus_effect_enabled(0, 0, false))


func _process(_delta: float) -> void:
	energy_bar.global_position = gun.sprite.global_position
	
	if is_invincible():
		animated_sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	else:
		animated_sprite.modulate = Color.WHITE
	
	if velocity.is_zero_approx():
		animated_sprite.play(&"idle")
	else:
		animated_sprite.play(&"walk")
	
	var blur_effect_mat: ShaderMaterial = blur_effect.material
	if health.value <= 1:
		var t: float = remap(heartbeat_timer.time_left, 0.0, heartbeat_timer.wait_time, 0.0, 1.0)
		blur_effect_mat.set_shader_parameter(&"lod", t)
	else:
		blur_effect_mat.set_shader_parameter(&"lod", 0.0)
	AudioServer.set_bus_effect_enabled(0, 0, health.value <= 1)
	
	if heartbeat_timer.is_stopped() == (health.value <= 1):
		if heartbeat_timer.is_stopped():
			heartbeat_timer.start()
			ringing_audio.play()
		else:
			heartbeat_timer.stop()
			ringing_audio.stop()


func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = get_input_vector()
	
	if not input_vector.is_zero_approx():
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
		moved.emit()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	velocity *= gun.movement_speed_multiplier
	
	if gun.fire_action() and knockback_enabled:
		velocity = (velocity + -Vector2.from_angle(gun.global_rotation) * gun.knockback).limit_length(velocity.length() + gun.max_knockback)
	
	move_and_slide()
	
	if global_position.x < 0.0:
		global_position.x = 0.0
		velocity.x = 0.0
	if global_position.x > 480.0:
		global_position.x = 480.0
		velocity.x = 0.0
	if global_position.y < 0.0:
		global_position.y = 0.0
		velocity.y = 0.0
	if global_position.y > 360.0:
		global_position.y = 360.0
		velocity.y = 0.0


func get_input_vector() -> Vector2:
	if Settings.no_move:
		return Vector2.ZERO
	
	return Input.get_vector(
		&"move_left",
		&"move_right",
		&"move_up",
		&"move_down",
	)


func _die() -> void:
	pass


func is_invincible() -> bool:
	return not invincibility_timer.is_stopped()


func _on_hit_detector_area_entered(area: Area2D) -> void:
	if is_invincible():
		return
	
	area.root._on_hit_player()
	
	health.value -= 1


func _on_health_value_lowered() -> void:
	damage_audio.play()
	invincibility_timer.start()


func _on_invincibility_timer_timeout() -> void:
	for area in hitbox.get_overlapping_areas():
		_on_hit_detector_area_entered(area)


func _on_heartbeat_timer_timeout() -> void:
	heartbeat_audio.play()
