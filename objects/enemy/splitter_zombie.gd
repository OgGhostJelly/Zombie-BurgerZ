extends Enemy


var should_split: bool = true


func _die() -> void:
	if is_dead:
		return
	
	is_dead = true
	
	spawn_split(Vector2(-8.0, 0.0))
	spawn_split(Vector2( 8.0, 0.0))
	
	queue_free()


func spawn_split(offset: Vector2) -> void:
	var scene: PackedScene = preload("res://objects/enemy/splitter_half_zombie.tscn")
	var obj: Node2D = scene.instantiate()
	obj.global_position = global_position + offset
	
	if not should_split:
		obj.ready.connect(func():
			obj.health.value = 0)
	
	call_deferred(&"add_sibling", obj)


func _on_hit_detector_hurt(info: HitInfo2D) -> void:
	var bullet: Bullet = info.hitbox as Bullet
	if bullet != null and health.max_value == bullet.pierce:
		should_split = false
	else:
		should_split = true
	
	super(info)
