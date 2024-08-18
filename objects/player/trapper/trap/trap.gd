extends Area2D

signal died


@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_dead: bool = false
var velocity: Vector2 = Vector2.ZERO
var cooldown: float = 0.1


func _ready() -> void:
	velocity = global_position.direction_to(get_global_mouse_position()) * 64.0
	rotation = randf_range(-PI/4, PI/4)


func _process(delta: float) -> void:
	if cooldown > 0.0:
		cooldown -= delta
	
	velocity = velocity.move_toward(Vector2.ZERO, 128.0 * delta)
	global_position += velocity * delta


func _on_area_entered(_area: Area2D) -> void:
	if is_dead:
		return
	
	if cooldown > 0.0:
		return
	
	is_dead = true
	var obj: Node2D = preload("res://objects/player/trapper/trap/explosion.tscn").instantiate()
	obj.global_position = global_position
	call_deferred(&"add_sibling", obj)
	animation_player.play(&"die")
	died.emit()
