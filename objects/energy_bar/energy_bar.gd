@tool
extends CircularProgressBar
class_name EnergyBar

signal used

@export var player: Player
@export var regeneration_speed: float = 0.0


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	value = maxf(value - (1.0 / regeneration_speed) * delta, 0.0)


func can_use() -> bool:
	return value <= 0.0


func use() -> bool:
	if can_use():
		force_use()
		return true
	return false


func force_use() -> void:
	value += 1.0
	used.emit()
