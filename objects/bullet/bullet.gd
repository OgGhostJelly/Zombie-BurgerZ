extends Hitbox2D
class_name Bullet

signal killed(enemy: Node)
signal checked_hit(info: HurtInfo2D)

@export var speed: float = 450.0
@export var pierce: int = 1
@export var damage: int = 1

@onready var sprite: Sprite2D = $Sprite2D

var direction: Vector2
var history: Array[HurtInfo2D]
var kills: int = 0
var hits: int = 0


func _ready() -> void:
	assert(is_in_group(&"bullets"))
	
	var spawner_info: Dictionary = get_meta(&"spawner_info")
	global_position = spawner_info.global_position
	global_rotation = spawner_info.global_rotation
	direction = Vector2.from_angle(rotation)
	sprite.flip_v = rotation < -PI/2.0 or rotation > PI/2.0


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_hit(info: HurtInfo2D) -> void:
	if info.hurtbox.root.is_invincible():
		return
	
	if info.hurtbox.root.killer:
		return
	
	history.append(info)
	
	pierce -= info.hurtbox.root.skin_pierce_strength
	
	if pierce <= 0:
		var debris: Node2D = preload("res://objects/bullet_debris/bullet_debris.tscn").instantiate()
		debris.global_position = global_position
		get_parent().add_child(debris)
		queue_free()
	
	if info.hurtbox.root.health.is_lowest():
		info.hurtbox.root.killer = self
		kills += 1
		killed.emit(info.hurtbox.root)
	
	hits += 1
	checked_hit.emit(info)
