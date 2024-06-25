extends Area2D


@onready var animation_player: AnimationPlayer = $SpawnAnimationPlayer


func _process(delta: float) -> void:
	for node in get_overlapping_bodies():
		var enemy: Enemy = node as Enemy
		if enemy == null:
			return
		
		enemy.global_position += (
			enemy.global_position.direction_to(global_position) *
			enemy.global_position.distance_to(global_position) *
			delta
		)


func _on_life_timer_timeout() -> void:
	animation_player.play(&"die")
