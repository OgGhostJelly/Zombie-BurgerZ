extends Character2D
class_name Player

signal moved

enum PlayerType {
	Normal,
	Dash,
	Blast
}

static var player_data: Dictionary = {
	PlayerType.Normal: {
		scene = preload("res://objects/player/normal_player.tscn"),
		texture = preload("res://assets/player/normal_player/player-idle.svg"),
		cost = 0,
		
		description = "normal guy. probably called joe",
	},
	PlayerType.Dash: {
		scene = preload("res://objects/player/dash_player.tscn"),
		texture = preload("res://assets/player/dash_player/player-idle.svg"),
		cost = 100,
		
		description = "kill to charge up a dash",
	},
	PlayerType.Blast: {
		scene = preload("res://objects/player/blast_player.tscn"),
		texture = preload("res://assets/player/blast_player/player-idle.svg"),
		cost = 200,
		
		description = "likes touhou. has bad eyesight",
	},
}

@export var speed: float = 120.0
@export var acceleration: float = 600.0
@export var deceleration: float = 400.0

@onready var gun: Gun = $Gun
@onready var health_ui: Control = $HealthUI
@onready var ammo_ui: Control = $AmmoUI
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var damage_audio: AudioStreamPlayer = $DamageAudio
@onready var energy_bar: EnergyBar = $EnergyBar
@onready var hitbox: Area2D = $HitDetector

static var player: Player


func _init() -> void:
	if scene_file_path:
		return
	
	var obj: Gun = Gun.gun_data[PlayerData.selected_gun].scene.instantiate()
	obj.name = "Gun"
	add_child(obj)


func _ready() -> void:
	super()
	player = self


func _physics_process(delta: float) -> void:
	energy_bar.global_position = gun.sprite.global_position
	
	if is_invincible():
		animated_sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	else:
		animated_sprite.modulate = Color.WHITE
	
	var input_vector: Vector2 = get_input_vector()
	
	if not input_vector.is_zero_approx():
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
		moved.emit()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	if velocity.is_zero_approx():
		animated_sprite.play(&"idle")
	else:
		animated_sprite.play(&"walk")
	
	if gun.fire_action():
		velocity = (velocity + -Vector2.from_angle(gun.global_rotation) * gun.knockback).limit_length(velocity.length() + gun.max_knockback)
	
	move_and_slide()
	
	global_position = global_position.clamp(Vector2.ZERO, Vector2(480.0, 360.0))
	
	queue_redraw()


func get_input_vector() -> Vector2:
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


func _on_hit_detector_area_entered(_area: Area2D) -> void:
	if is_invincible():
		return
	
	damage_audio.play()
	invincibility_timer.start()
	health.value -= 1


func _on_invincibility_timer_timeout() -> void:
	for area in hitbox.get_overlapping_areas():
		_on_hit_detector_area_entered(area)
