extends Character2D
class_name Enemy


@export var speed: float = 45.0
@export var money_count: int = 0

@onready var context_steerer: ContextSteerer = $ContextSteerer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sight_detector: Area2D = $SightDetector
@onready var hit_audio: AudioStreamPlayer = $HitAudio


func _ready() -> void:
	super()
	animated_sprite.play(&"walk0")
	
	speed = randf_range(45.0 - 7.5, 45.0 + 7.5)
	money_count = randi_range(2, 4)
	
	health.value_changed.connect(func():
		if health.value > 0: animated_sprite.play(&"walk" + str(health.max_value - health.value)))


func _process(_delta: float) -> void:
	var player: Node2D = get_player()
	
	context_steerer.target_direction = global_position.direction_to(player.global_position)
	
	for area in sight_detector.get_overlapping_areas():
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


func get_player() -> CharacterBody2D:
	var players: Array[Node] = get_tree().get_nodes_in_group(&"player")
	return players[0]


func _die() -> void:
	var debris: Node2D = preload("res://objects/enemy_debris/enemy_debris.tscn").instantiate()
	debris.global_position = global_position
	debris.set_enemy(self)
	get_parent().add_child(debris)
	
	if randf() < 1.0 / 25.0:
		if Player.player.health.value < Player.player.health.max_value:
			_drop(preload("res://objects/pickup/health_pickup.tscn"), 1)
		else:
			_drop(preload("res://objects/pickup/money_pickup.tscn"), 10)
	
	_drop(preload("res://objects/pickup/money_pickup.tscn"), money_count)
	
	queue_free()


func _drop(scene: PackedScene, amount: int) -> void:
	for i in amount:
		var drop: Node2D = scene.instantiate()
		drop.global_position = global_position
		get_parent().call_deferred(&"add_child", drop)


func _on_hit_detector_hurt(_hitbox: HitInfo2D) -> void:
	hit_audio.play()
	health.value -= 1
