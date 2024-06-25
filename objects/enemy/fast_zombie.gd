extends Enemy


func _on_hit_player() -> void:
	health.value -= 1
