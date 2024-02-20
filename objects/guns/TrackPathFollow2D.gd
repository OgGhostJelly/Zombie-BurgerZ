extends PathFollow2D
class_name TrackPathFollow2D

signal fined
signal reached_end


@export var offroad_fine: float = 0.1
@export var danger_distance_squared: float = 65536.0
@export var sample_precision: float = 10.0

@export var following_node: Node


func _ready() -> void:
	set(&"_direct_set_loop", false)


func _process(_delta: float) -> void:
	if following_node == null:
		return
	
	if global_position.distance_squared_to(following_node.global_position) > danger_distance_squared:
		progress_ratio -= offroad_fine
		following_node.global_position = global_position
		fined.emit()
		return
	
	var curve: Curve2D = $"..".curve
	var direction: Vector2 = curve.sample_baked(progress - sample_precision).direction_to(curve.sample_baked(progress + sample_precision))
	var move_amount: float = -direction.dot(global_position - following_node.global_position)
	
	var old_progress: float = progress
	progress += move_amount
	
	if progress != old_progress and progress_ratio >= 1.0:
		progress_ratio = 0.0
		reached_end.emit()
  

func _draw() -> void:
	draw_circle(Vector2.ZERO, 10.0, Color.BLUE)


func _set(property: StringName, value: Variant) -> bool:
	if property == &"_direct_set_loop":
		loop = value
		return true
	if property == &"loop":
		return true
	
	return false
