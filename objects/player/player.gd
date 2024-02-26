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
@onready var reload_timer: Timer = $ReloadTimer


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
	
	if not reload_timer.is_stopped():
		velocity = Vector2.ZERO
	
	if velocity.is_zero_approx():
		animated_sprite.play(&"idle")
	else:
		animated_sprite.play(&"walk")
	
	if Input.is_action_just_pressed(&"fire"):
		gun.fire()
	
	move_and_slide()
	
	if not velocity.is_zero_approx():
		moved.emit()
	
	if gun.can_reload() and Input.is_action_just_pressed(&"reload") and reload_timer.is_stopped():
		reload_timer.start()
	
	queue_redraw()


func _draw() -> void:
	draw_arc(
		Vector2.ZERO,
		32.0,
		-PI/2.0,
		(-TAU * (reload_timer.time_left / reload_timer.wait_time)) - PI/2.0,
		64,
		Color.YELLOW,
		2.0
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


func _on_reload_timer_timeout() -> void:
	gun.force_reload()
