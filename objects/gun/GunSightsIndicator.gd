extends Node2D


@export var gun: Gun
@export var enabled: bool = true


func _ready() -> void:
	enabled = Challenge.gun_sights
	visible = enabled


func _process(_delta: float) -> void:
	if enabled:
		queue_redraw()


func _draw() -> void:
	if gun.bullets_per_shot <= 1:
		var half_spread: float = deg_to_rad(gun.spread / 2.0)
	
		var points: PackedVector2Array = []
		points.append(Vector2.ZERO)
		points.append(Vector2.RIGHT.rotated(-half_spread) * 640.0)
		points.append(Vector2.RIGHT.rotated(half_spread)  * 640.0)
		points.append(Vector2.ZERO)
		points.append(Vector2.ZERO)
		draw_polyline(points, Color(0.0, 0.0, 1.0, 0.5))
		return
	
	for idx in gun.bullets_per_shot:
		var angle: float = deg_to_rad(remap(idx + 0.5, 0, gun.bullets_per_shot, -gun.spread, gun.spread))
		draw_line(Vector2.ZERO, Vector2.RIGHT.rotated(angle) * 640.0, Color(0.0, 0.0, 1.0, 0.5))
