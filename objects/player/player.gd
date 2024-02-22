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
@onready var stats_tracker: StatsTracker = $StatsTracker

var last_mouse_position: Vector2
var reload_percentage: float = 0.0


func _ready() -> void:
	last_mouse_position = get_global_mouse_position()
	
	health_changed.connect(func():
		health_ui.health = health)
	
	max_health_changed.connect(func():
		health_ui.max_health = max_health)
	
	gun.ammo_changed.connect(func():
		ammo_ui.ammo = gun.ammo)
	
	gun.max_ammo_changed.connect(func():
		ammo_ui.max_ammo = gun.max_ammo)
	
	gun.fired.connect(func():
		reload_percentage = 0.0)
	
	ammo_ui.ammo = gun.ammo
	ammo_ui.max_ammo = gun.max_ammo


func _physics_process(delta: float) -> void:
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

	if gun.can_reload():
		var mouse_position: Vector2 = get_global_mouse_position()
		if global_position.distance_squared_to(mouse_position) < 64**2: 
			reload_percentage += mouse_position.distance_to(last_mouse_position) * delta * 0.15
		last_mouse_position = mouse_position
		
		if reload_percentage > 1.0:
			reload_percentage -= 1.0
			gun.force_reload()
	else:
		reload_percentage = 0.0
	
	for i in gun.max_ammo:
		var ui: TextureRect = ammo_ui.get_node_or_null("%s" % i)
		if ui != null:
			ui.material.set_shader_parameter(&"top", (
				1.0
				if i < gun.ammo else
				0.0
				if i != gun.ammo else
				reload_percentage
			))
	
	global_position = global_position.clamp(Vector2.ZERO + Vector2(4.0, 16.0), Vector2(480.0, 360.0)  - Vector2(4.0, 16.0))
	
	queue_redraw()


func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	health_ui.health = value


func set_max_health(value: int) -> void:
	max_health = value
	health_ui.max_health = value

func _die() -> void:
	get_tree().call_deferred(&"reload_current_scene") main


func _on_hit_detector_area_entered(_area: Area2D) -> void:
	if invincible:
		return
	
	damage_audio.play()
	invincibility_timer.start()
	invincible = true
	animated_sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	health -= 1


func _on_invincibility_timer_timeout() -> void:
	animated_sprite.modulate = Color.WHITE
	invincible = false
