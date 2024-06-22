extends Area2D
class_name Pickup


@export var fade_time: float = -1.0
@export var cooldown_time: float = 0.0
@onready var velocity: Vector2 = Vector2.from_angle(randf_range(-PI, PI)) * 128.0
@onready var particles: CPUParticles2D = $Particles
@onready var pickup_audio: AudioStreamPlayer = $PickupAudio
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@onready var target: Player = Player.player
@onready var _rotate_axis: float = [-1.0, 1.0].pick_random()
@onready var _fading: float = 1.0


func _ready() -> void:
	rotation = randf_range(-PI, PI)
	
	if cooldown_time > 0.0:
		collision_shape.disabled = true
		cooldown_timer.wait_time = cooldown_time
		cooldown_timer.start()


func _process(delta: float) -> void:
	if fade_time >= 0.0:
		_fading -= delta / fade_time
		if _fading <= 0.0:
			queue_free()
		modulate = Color(1.0, 1.0, 1.0, _fading + 0.2)
	
	if not is_instance_valid(target):
		target = get_tree().get_nodes_in_group(&"player")[0]
	
	if target != null and _can_pickup(target) and cooldown_timer.is_stopped():
		global_position += global_position.direction_to(target.global_position) * abs(256.0 - global_position.distance_to(target.global_position)) * delta
	
	rotation += PI * delta * _rotate_axis
	velocity = velocity.move_toward(Vector2.ZERO, delta * 256.0)
	global_position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player == null:
		return
	
	if not _can_pickup(player):
		return
	
	particles.emitting = true
	particles.reparent(get_parent())
	
	pickup_audio.play()
	pickup_audio.finished.connect(func():
		pickup_audio.queue_free())
	pickup_audio.reparent(get_parent())
	
	_pickup(player)
	
	queue_free()


func _on_cooldown_timer_timeout() -> void:
	collision_shape.disabled = false


func _can_pickup(_player: Player) -> bool:
	return true


func _pickup(_player: Player) -> void:
	pass


func _fade() -> float:
	return -1.0
