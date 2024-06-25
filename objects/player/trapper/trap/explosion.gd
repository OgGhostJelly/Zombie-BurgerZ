extends Hitbox2D


@export var damage: int = 3
#https://sfxr.me/#84AYGJkhjSWj6hkud2UaRaRuLf8e7B9fxYy6ntkF7Fj5HGLg2qfkDeRN4F7YD77fWy3F4pnj1CNBuwdhFjKQKzuZctjPyLVjNuw8u6yKtMR4YeoEiVR1sKSxP
func _process(delta: float) -> void:
	for node in get_overlapping_bodies():
		node = node as Node2D
		if node == null:
			return
		
		node.global_position += (
			global_position.direction_to(node.global_position) *
			abs(96.0 - node.global_position.distance_to(global_position)) *
			3.0 *
			delta
		)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()


func _on_hit_player() -> void:
	pass
