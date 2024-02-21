extends Hitbox2D


@export var speed: float = 450.0

@onready var sprite: Sprite2D = $Sprite2D

var direction: Vector2


func _ready() -> void:
	var spawner_info: Dictionary = get_meta(&"spawner_info")
	global_position = spawner_info.global_position
	global_rotation = spawner_info.global_rotation
	direction = Vector2.from_angle(rotation)
	sprite.flip_v = rotation < -PI/2.0 or rotation > PI/2.0


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
