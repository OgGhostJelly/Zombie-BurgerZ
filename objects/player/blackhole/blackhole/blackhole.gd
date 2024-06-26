extends Area2D


@onready var animation_player: AnimationPlayer = $SpawnAnimationPlayer


func _process(delta: float) -> void:
	for value in get_overlapping_bodies():
		var node: Node2D = value as Node2D
		if node == null:
			return
		
		if not (node is Player or node is Enemy):
			return
		
		node.global_position += (
			node.global_position.direction_to(global_position) *
			node.global_position.distance_to(global_position) *
			delta
		)


func _on_life_timer_timeout() -> void:
	animation_player.play(&"die")
