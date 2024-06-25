extends Character2D
class_name Enemy


@export var speeds: float = 45.0
@export var money_count: Vector2i = Vector2i.ZERO
@export var skin_pierce_strength: int = 0

@onready var context_steerer: ContextSteerer = $ContextSteerer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sight_detector: Area2D = $SightDetector
@onready var hit_audio: AudioStreamPlayer = $HitAudio
@onready var hurtbox: Hurtbox2D = $HitDetector

var killer: Bullet
var speed: float


func _ready() -> void:
	super()
	animated_sprite.play(&"walk0")
	
	speed = randf_range(speeds * 0.8333333333333334, speeds * 1.1666666666666667)
	
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
	animated_sprite.reparent(debris)
	get_parent().add_child(debris)
	
	if randf() < 1.0 / 25.0:
		if Player.player.health.value < Player.player.health.max_value:
			_drop(preload("res://objects/pickup/health_pickup.tscn"), 1)
		else:
			_drop(preload("res://objects/pickup/money_pickup.tscn"), money_count.y * 2)
	
	_drop(preload("res://objects/pickup/money_pickup.tscn"), randi_range(money_count.x, money_count.y))
	
	queue_free()


func _drop(scene: PackedScene, amount: int) -> void:
	for i in amount:
		var drop: Node2D = scene.instantiate()
		drop.global_position = global_position
		get_parent().call_deferred(&"add_child", drop)


func _on_hit_detector_hurt(info: HitInfo2D) -> void:
	hit_audio.play()
	health.value -= info.hitbox.root.damage
	hurtbox.hurt_info = HurtInfo2D.new()


func _on_hit_player() -> void:
	pass
