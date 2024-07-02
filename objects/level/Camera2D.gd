extends Camera2D


func _process(delta: float) -> void:
	zoom = zoom.lerp(Vector2(1, 1), 1.0 - pow(0.6, delta))
