extends Character2D
class_name Player

signal moved

@export var speed: float = 120.0
@export var acceleration: float = 600.0
@export var deceleration: float = 400.0
 
var invincible: bool = false

@onready var gun: Gun = $Gun
@onready var health_ui: Control = $HealthUI
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var damage_audio: AudioStreamPlayer = $DamageAudio


func _ready() -> void:
	super()
	health.value_changed.connect(func():
		health_ui.health = health.value)
	
	health.max_value_changed.connect(func():
		health_ui.max_health = health.max_value)


func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector(
		&"move_left",
		&"move_right",
		&"move_up",
		&"move_down",
	)
	
	if not input_vector.is_zero_approx():
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
		moved.emit()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	if velocity.is_zero_approx():
		animated_sprite.play(&"idle")
	else:
		animated_sprite.play(&"walk")
	
	if Input.is_action_just_pressed(&"fire") and gun.fire():
		velocity = (velocity + -Vector2.from_angle(gun.global_rotation) * 160.0).limit_length(velocity.length() + 80.0)
	
	move_and_slide()
	
	queue_redraw()


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
