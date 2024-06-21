extends Node2D


@export var expire_time: float = 30.0
@onready var _t: float = expire_time

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var _enemy_flip_h: bool


func _ready() -> void:
	animated_sprite.play(&"death")
	animated_sprite.flip_h = _enemy_flip_h


func _process(delta: float) -> void:
	_t -= delta
	modulate = Color(1.0, 1.0, 1.0, _t / expire_time)
	
	if _t <= 0.0:
		queue_free() 


func set_enemy(enemy: Enemy) -> void:
	_enemy_flip_h = enemy.animated_sprite.flip_h
