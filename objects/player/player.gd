extends Character2D
class_name Player

signal moved

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

static var player: Player


func _init() -> void:
	var obj: Gun = Gun.gun_data[PlayerData.selected_gun].scene.instantiate()
	obj.name = "Gun"
	add_child(obj)


func _ready() -> void:
	super()
	player = self


func _physics_process(delta: float) -> void:
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
	pass
