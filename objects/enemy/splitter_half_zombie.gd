extends Enemy


var invincible: bool = true


func _ready() -> void:
	super()
	await get_tree().create_timer(0.1).timeout
	invincible = false


func is_invincible() -> bool:
	return super() or invincible


func _on_hit_player() -> void:
	health.value -= 1
