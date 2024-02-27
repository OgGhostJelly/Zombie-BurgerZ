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
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var damage_audio: AudioStreamPlayer = $DamageAudio


func _ready() -> void:
	super()
	health.value_changed.connect(func():
		health_ui.health = health.value)
	
	health.max_value_changed.connect(func():
		health_ui.max_health = health.max_value)


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
