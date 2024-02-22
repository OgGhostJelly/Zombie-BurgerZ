extends PathFollow2D
class_name TrackPathFollow2D


@export var danger_distance_squared: float = 32**2


func _ready() -> void:
	set(&"_direct_set_loop", false)


func update(to: Vector2) -> bool:
	if global_position.distance_squared_to(to) > danger_distance_squared:
		return false 
	
	var curve: Curve2D = $"..".curve
	var direction: Vector2 = curve.sample_baked(progress - 1.0).direction_to(curve.sample_baked(progress + 1.0))
	var move_amount: float = -direction.dot(global_position - to)
	
	var old_progress: float = progress
	progress += move_amount
	
	if progress != old_progress and progress_ratio >= 1.0:
		progress = 0.0
		return true
	return false


func _set(property: StringName, value: Variant) -> bool:
	if property == &"_direct_set_loop":
		loop = value
		return true
	if property == &"loop":
		return true
	
	return false
