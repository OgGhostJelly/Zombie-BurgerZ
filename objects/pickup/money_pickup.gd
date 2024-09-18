extends Pickup


func _pickup(_player: Player) -> void:
	UserData.money += 1
