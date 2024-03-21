extends Character2D


@export var speed: float = 45.0

@onready var context_steerer: ContextSteerer = $ContextSteerer
@onready var death_audio: AudioStreamPlayer = $DeathAudio
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_sight_detector: Area2D = $GunSightDetector
@onready var player_sight_detector: Area2D = $PlayerSightDetector

var last_seen_position: Vector2
var last_seen_is_valid: bool

var random_moving: bool
var random_direction: Vector2


func _ready() -> void:
	super()
	last_seen_position = global_position
	animated_sprite.play(&"walk0")
	
	health.value_changed.connect(func():
		if health.value > 0: animated_sprite.play(&"walk" + str(health.max_value - health.value)))


func _process(_delta: float) -> void:
	var target_direction: Vector2
	
	for node in player_sight_detector.get_overlapping_bodies():
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(
			global_position,
			node.global_position,
			0b10000)
		query.hit_from_inside = false
		var result = space_state.intersect_ray(query)
		
		if not result.is_empty():
			continue
		
		last_seen_position = node.global_position
		target_direction = global_position.direction_to(node.global_position)
		last_seen_is_valid = true
		break
	
	if target_direction.is_zero_approx() and last_seen_is_valid:
		target_direction = global_position.direction_to(last_seen_position)
		if global_position.distance_squared_to(last_seen_position) < 16.0 ** 2:
			last_seen_is_valid = false
	
	if target_direction.is_zero_approx() and random_moving:
		target_direction = random_direction.normalized()
	
	context_steerer.target_direction = target_direction
	
	for area in gun_sight_detector.get_overlapping_areas():
		context_steerer.target_direction = context_steerer.target_direction.rotated(PI/4.0)
	
	context_steerer.update_direction()
	velocity = context_steerer.direction * speed
	
	animated_sprite.flip_h = context_steerer.direction.angle() < -PI/2.0 or context_steerer.direction.angle() > PI/2.0
	
	animated_sprite.offset = (
		Vector2(-22.0, 0.0)
		if animated_sprite.flip_h else
		Vector2.ZERO
	)
	
	move_and_slide()


func _die() -> void:
	animated_sprite.play(&"death")
	animated_sprite.reparent(get_parent())
	
	death_audio.play()
	death_audio.finished.connect(func():
		death_audio.queue_free())
	death_audio.reparent(get_parent())
	
	queue_free()


func _on_hit_detector_hurt(_hitbox: HitInfo2D) -> void:
	health.value -= 1


func _on_random_move_timer_timeout() -> void:
	random_moving = randf() > 0.5
	random_direction = Vector2(randf(), randf()).normalized()
