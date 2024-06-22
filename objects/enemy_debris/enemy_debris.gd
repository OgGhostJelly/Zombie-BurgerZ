extends Node2D


@export var expire_time: float = 30.0
@onready var _t: float = expire_time

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite.play(&"death")


func _process(delta: float) -> void:
	_t -= delta
	modulate = Color(1.0, 1.0, 1.0, _t / expire_time)
	
	if _t <= 0.0:
		queue_free() 
