extends CharacterBody2D

signal died


@export var max_health: int = 3
@export var health: int = 3: set = set_health
@export var speed: float = 45.0

@onready var context_steerer: ContextSteerer = $ContextSteerer
@onready var death_audio: AudioStreamPlayer = $DeathAudio
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite.play(&"walk0")


func _process(_delta: float) -> void:
	var player: Node2D = get_player()
	
	context_steerer.target_direction = to_local(player.global_position)
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


func _on_hit_detector_area_entered(_area: Area2D) -> void:
	health -= 1


func set_health(value: int) -> void:
	health = value
	
	if health <= 0:
		animated_sprite.play(&"death")
		animated_sprite.reparent(get_parent())
		
		death_audio.play()
		death_audio.finished.connect(func():
			death_audio.queue_free())
		death_audio.reparent(get_parent())
		
		died.emit()
		queue_free()
	else:
		animated_sprite.play(&"walk" + str(max_health - health))
