extends Node2D


func _ready() -> void:
	global_position = global_position.clamp(
		Vector2.ZERO + Vector2(8.0, 16.0),
		Vector2(480.0, 360.0) - Vector2(8.0, 16.0))


func _on_free_timer_timeout() -> void:
	queue_free()
