extends Enemy


func _on_hit_detector_hurt(hitbox: HitInfo2D) -> void:
	super(hitbox)
	health.value -= 1
