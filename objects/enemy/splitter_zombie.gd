extends Enemy


func _die() -> void:
	if is_dead:
		return
	
	is_dead = true
	
	var obj: Node2D = preload("res://objects/enemy/splitter_half_zombie.tscn").instantiate()
	obj.global_position = global_position - Vector2(8.0, 0.0)
	call_deferred(&"add_sibling", obj)
	
	obj = preload("res://objects/enemy/splitter_half_zombie.tscn").instantiate()
	obj.global_position = global_position + Vector2(8.0, 0.0)
	call_deferred(&"add_sibling", obj)
	
	queue_free()
