@tool
extends Node2D
class_name CircularProgressBar


@export_range(-TAU, TAU) var start_angle: float = -PI: set = set_start_angle
@export_range(-TAU, TAU) var end_angle: float = PI: set = set_end_angle
@export var radius: float = 64.0: set = set_radius
@export var point_count: int = 16: set = set_point_count
@export var width: float = -1.0: set = set_width
@export_range(0.0, 1.0) var value: float = 0.0: set = set_value
@export var enable_debug: bool = true: set  = set_enable_debug
@export var color: Color = Color.WHITE: set = set_color


func set_value(v: float) -> void:
	value = v
	queue_redraw()


func set_color(v: Color) -> void:
	color = v
	queue_redraw()


func set_enable_debug(v: bool) -> void:
	enable_debug = v
	queue_redraw()


func set_width(v: float) -> void:
	width = v
	queue_redraw()


func set_radius(v: float) -> void:
	radius = v
	queue_redraw()


func set_point_count(v: int) -> void:
	point_count = v
	queue_redraw()


func set_start_angle(v: float) -> void:
	start_angle = v
	queue_redraw()


func set_end_angle(v: float) -> void:
	end_angle = v
	queue_redraw()


func _draw() -> void:
	if Engine.is_editor_hint() and enable_debug:
		draw_circle(Vector2.from_angle(end_angle) * radius, width * 2.0, Color(1.0, 0.0, 0.0, 0.5))
		draw_circle(Vector2.from_angle(start_angle) * radius, width * 2.0, Color(0.0, 1.0, 0.0, 0.5))
	
	draw_arc(Vector2.ZERO, radius, start_angle, snappedf(lerpf(start_angle, end_angle, value), 0.001), point_count, color, width)
