extends Character2D


@export var speed: float = 45.0

@onready var context_steerer: ContextSteerer = $ContextSteerer
@onready var death_audio: AudioStreamPlayer = $DeathAudio
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sight_detector: Area2D = $SightDetector

var preferred_angle: float = 1 if randf() > 0.5 else -1


func _ready() -> void:
	animated_sprite.play(&"walk0")
	
	health_changed.connect(func():
		if health > 0: animated_sprite.play(&"walk" + str(max_health - health)))


func _process(_delta: float) -> void:
	var player: Node2D = get_player()
	
	context_steerer.target_direction = to_local(player.global_position)
	
	for area in sight_detector.get_overlapping_areas():
		context_steerer.target_direction = context_steerer.target_direction.rotated(
			preferred_angle * PI/2.0)
	
	context_steerer.update_direction()
	velocity = context_steerer.direction * speed
	
	animated_sprite.flip_h = context_steerer.direction.angle() < -PI/2.0 or context_steerer.direction.angle() > PI/2.0
	
	animated_sprite.offset = (
		Vector2(-22.0, 0.0)
		if animated_sprite.flip_h else
		Vector2.ZERO
	)
	
	move_and_slide()


func get_player() -> CharacterBody2D:
	var players: Array[Node] = get_tree().get_nodes_in_group(&"player")
	return players[0]


func _die() -> void:
	animated_sprite.play(&"death")
	animated_sprite.z_index -= 1
	animated_sprite.reparent(get_parent())
	
	death_audio.play()
	death_audio.finished.connect(func():
		death_audio.queue_free())
	death_audio.reparent(get_parent())
	
	died.emit()
	queue_free()


func _on_hit_detector_hurt(_hitbox: HitInfo2D) -> void:
	health -= 1
