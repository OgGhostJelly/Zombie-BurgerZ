extends Pickup


func _pickup(player: Player) -> void:
	player.gun.ammo.max_value += 1
