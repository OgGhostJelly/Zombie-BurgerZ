extends CharacterBody2D


# close-up to reload is fine cus being close to player worsens aim


@export var max_health: int = 5: set = set_max_health
@export var reload_empty_color: Color = Color.BLUE
@export var reload_fill_color: Color = Color.YELLOW

var health: int = max_health: set = set_health
var invincible: bool = false

@onready var gun: Node2D = $Gun
@onready var health_ui: Control = $HealthUI
@onready var ammo_ui: Control = $AmmoUI
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var reload_path: Path2D = $ReloadPath
@onready var reload_path_follow: TrackPathFollow2D = $ReloadPath/ReloadPathFollow
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var damage_audio: AudioStreamPlayer = $DamageAudio


func _ready() -> void:
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
	
	if Input.is_action_just_pressed(&"shoot"):
		gun.shoot()
	
	move_and_slide()
	
	if gun.can_reload() and reload_path_follow.update(get_global_mouse_position()):
		gun.force_reload()
	
	global_position = global_position.clamp(Vector2.ZERO + Vector2(4.0, 16.0), Vector2(480.0, 360.0)  - Vector2(4.0, 16.0))
	
	queue_redraw()


func _draw() -> void:
	var points0: PackedVector2Array = []
	
	for i in reload_path.curve.point_count:
		for j in 10:
			var k = j / 10.0
			points0.append(reload_path.curve.sample(i, k) + reload_path.position)
	
	draw_polyline(
		points0,
		reload_empty_color if gun.can_reload() else reload_fill_color,
		-1.0 if gun.can_reload() else 2.0
	)
	
	var points1: PackedVector2Array = []
	var length: float = reload_path.curve.get_baked_length()
	
	for i in length:
		if i > reload_path_follow.progress:
			break
		
		points1.append(reload_path.curve.sample_baked(i) + reload_path.position)
	
	if points1.size() == 1:
		points1.append(points1[0])
	
	draw_polyline(
		points1,
		reload_fill_color,
		2.0
	)
	
	draw_circle(reload_path_follow.position.rotated(-rotation) + reload_path.position, 4.0, reload_fill_color)


func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	health_ui.health = value


func set_max_health(value: int) -> void:
	max_health = value
	health_ui.max_health = value


func _on_hit_detector_area_entered(_area: Area2D) -> void:
	if invincible:
		return
	
	damage_audio.play()
	invincibility_timer.start()
	invincible = true
	animated_sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	health -= 1
	
	if health <= 0:
		get_tree().quit()


func _on_invincibility_timer_timeout() -> void:
	animated_sprite.modulate = Color.WHITE
	invincible = false
