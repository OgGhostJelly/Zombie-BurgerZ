extends Pickup


func _pickup(_player: Player) -> void:
	PlayerData.money += 1
