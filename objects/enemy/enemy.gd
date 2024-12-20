extends Character2D
class_name Enemy


@export var speeds: float = 45.0
@export var money_count: Vector2i = Vector2i.ZERO
@export var skin_pierce_strength: int = 0
@export var face_left_offset: Vector2 = Vector2(-22.0, 0.0)
@export var should_flip: bool = true


@onready var context_steerer: ContextSteerer = $ContextSteerer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sight_detector: Area2D = $SightDetector
@onready var hit_audio: AudioStreamPlayer = $HitAudio
@onready var hurtbox: Hurtbox2D = $HitDetector

var killer: Bullet
var speed: float
var is_dead: bool = false


func _ready() -> void:
	super()
	animated_sprite.play(&"walk0")
	
	speed = randf_range(speeds * 0.8333333333333334, speeds * 1.1666666666666667)
	
	health.value_changed.connect(func():
		if health.value > 0: animated_sprite.play(&"walk" + str(health.max_value - health.value)))
	
	var total: float = Settings.get_money_multiplier()
	var money_multiplier: int = floor(total)
	var decimal_part: float = total - money_multiplier
	if decimal_part > randf():
		money_multiplier += 1
	
	money_count.x *= money_multiplier
	money_count.y *= money_multiplier


func _process(_delta: float) -> void:
	context_steerer.target_direction = global_position.direction_to(Player.player.global_position)
	
	for area in sight_detector.get_overlapping_areas():
		context_steerer.target_direction = context_steerer.target_direction.rotated(PI/4.0)
	
	context_steerer.update_direction()
	velocity = context_steerer.direction * speed
	
	animated_sprite.flip_h = should_flip and (context_steerer.direction.angle() < -PI/2.0 or context_steerer.direction.angle() > PI/2.0)
	
	animated_sprite.offset = (
		face_left_offset
		if animated_sprite.flip_h else
		Vector2.ZERO
	)
	
	move_and_slide()


func _die() -> void:
	if is_dead:
		return
	
	is_dead = true
	
	hit_audio.reparent(get_parent())
	if hit_audio.playing:
		hit_audio.finished.connect(func():
			queue_free())
	else:
		queue_free()
	
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
	if is_invincible():
		return
	
	health.value -= info.hitbox.root.damage
	hurtbox.hurt_info = HurtInfo2D.new()


func _on_health_value_lowered() -> void:
	if hit_audio:
		hit_audio.play()


func is_invincible() -> bool:
	return false


func _on_hit_player() -> void:
	pass
