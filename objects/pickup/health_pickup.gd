extends Pickup


func _can_pickup(player: Player) -> bool:
	return player.health.value < player.health.max_value


func _pickup(player: Player) -> void:
	player.health.value += 1
