extends Character2D
class_name Player

signal moved

#@export var max_health: int = 5: set = set_max_health
@export var reload_empty_color: Color = Color.BLUE
@export var reload_fill_color: Color = Color.YELLOW

#var health: int = max_health: set = set_health
var invincible: bool = false

@onready var gun: Gun = $Gun
@onready var health_ui: Control = $HealthUI
@onready var ammo_ui: Control = $AmmoUI
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var damage_audio: AudioStreamPlayer = $DamageAudio

var _reload_progress: float = 0.0
var _last_gun_direction: Vector2


func _ready() -> void:
	super()
	health.value_changed.connect(func():
		health_ui.health = health.value)
	
	health.max_value_changed.connect(func():
		health_ui.max_health = health.max_value)
	
	gun.ammo_changed.connect(func():
		ammo_ui.ammo = gun.ammo)
	
	gun.max_ammo_changed.connect(func():
		ammo_ui.max_ammo = gun.max_ammo)
	
	ammo_ui.ammo = gun.ammo
	ammo_ui.max_ammo = gun.max_ammo


func _physics_process(_delta: float) -> void:
	velocity = Input.get_vector(
		&"move_left",
		&"move_right",
		&"move_up",
		&"move_down",
	) * 90.0
	
	if velocity.is_zero_approx():
		animated_sprite.play(&"idle")
	else:
		animated_sprite.play(&"walk")
	
	if Input.is_action_just_pressed(&"fire"):
		gun.fire()
	
	move_and_slide()
	
	if not velocity.is_zero_approx():
		moved.emit()
	
	var gun_direction: Vector2 = Vector2.from_angle(gun.global_rotation)
	_reload_progress += _last_gun_direction.angle_to(gun_direction) / TAU
	_last_gun_direction = gun_direction
	
	if abs(_reload_progress) > 1.0:
		reset_reload_progress()
		gun.reload()
	
	if not gun.can_reload():
		reset_reload_progress()
	
	queue_redraw()


func reset_reload_progress() -> void:
	_reload_progress = sremap(gun.global_rotation) / TAU


func sremap(value: float) -> float:
	if value >= PI/2.0 and value <= PI:
		return value - PI - PI/2.0
	
	return value + PI/2.0


func _draw() -> void:
	draw_arc(
		Vector2.ZERO,
		32.0,
		-PI/2.0,
		TAU - PI/2.0,
		64,
		reload_empty_color,
		1.0
	)
	
	draw_arc(
		Vector2.ZERO,
		32.0,
		-PI/2.0,
		((TAU * _reload_progress) - PI/2.0)
		if gun.can_reload() else
		(TAU - PI/2.0),
		64,
		reload_fill_color,
		2.0
	)
	
	draw_circle(
		(Vector2.from_angle(gun.global_rotation) * 32.0)
		if gun.can_reload() else
		(Vector2.UP * 32.0),
		4.0,
		reload_fill_color
	)


func _die() -> void:
	get_tree().call_deferred(&"reload_current_scene")


func _on_hit_detector_area_entered(_area: Area2D) -> void:
	if invincible:
		return
	
	damage_audio.play()
	invincibility_timer.start()
	invincible = true
	animated_sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	health.value -= 1


func _on_invincibility_timer_timeout() -> void:
	animated_sprite.modulate = Color.WHITE
	invincible = false
