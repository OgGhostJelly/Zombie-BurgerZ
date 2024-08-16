extends Camera2D

var screen_shake_time: float = 0.0
var screen_shake_strength: float = 0.0
var screen_shake_speed: float = 0.0
var rest_speed: float = 0.0


func _ready() -> void:
	await get_parent().ready
	
	get_parent().kill_count_changed.connect(func():
		shake(0.15, 16.0, 0.4, 0.1))


func _process(delta: float) -> void:
	zoom = zoom.lerp(Vector2(1, 1), 1.0 - pow(0.6, delta))
	
	if screen_shake_time > 0.0:
		screen_shake_time -= delta
		var desired_position: Vector2 = Vector2(randf_range(-screen_shake_strength, screen_shake_strength), randf_range(-screen_shake_strength, screen_shake_strength))
		offset = offset.lerp(desired_position, 1.0 - pow(0.1, delta))
	else:
		screen_shake_time = 0.0
		offset = offset.lerp(Vector2.ZERO, 1.0 - pow(rest_speed, delta))


func shake(time: float = 1.0, strength: float = 8.0, speed: float = 0.1, p_rest_speed: float = 0.1) -> void:
	screen_shake_time = time
	screen_shake_strength = strength
	screen_shake_speed = speed
	rest_speed = p_rest_speed
