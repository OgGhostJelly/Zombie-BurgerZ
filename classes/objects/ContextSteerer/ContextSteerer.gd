extends Node2D
class_name ContextSteerer
## Contains methods for context steering.
##
## Using rays tries to walk in a direction while avoiding obstacles[br][br]Example:
## [codeblock]
## extends CharacterBody2D
## # In this example 'context_steerer' and 'speed' are not defined
## func _physics_process(_delta):
##     context_steerer.target_direction = Vector2.RIGHT # Move to the right
##     context_steerer.update_direction() # Update the direction
##     velocity = context_steerer.direction * speed
##     move_and_slide()
## [/codeblock]
##
## @tutorial[( Context-based Steering )]: https://kidscancode.org/godot_recipes/3.x/ai/context_map/


## The direction we want to acheive.
@export var target_direction: Vector2 = Vector2.ZERO
## How far we can detect obstacles.
@export var sight_distance: float = 128.0
## The amount of rays we send out to detect obstacles.
@export var number_of_rays: int = 8

## If [code]true[/code], the rays will take [Area2D]s into account. See [PhysicsRayQueryParameters2D] for more info.
@export var collide_with_areas: bool = false
## If [code]true[/code], the rays will take [PhysicsBody2D]s into account. See [PhysicsRayQueryParameters2D] for more info.
@export var collide_with_bodies: bool = true
## The physics layers the rays will detect (as bitmask). See [PhysicsRayQueryParameters2D] for more info.
@export_flags_2d_physics var collision_mask: int = 1

## Wether to show the debug rays.
@export var enable_debug_display: bool = false


var _ray_directions: Array[Vector2] = []
var _ray_interests: Array[float] = []
var _ray_dangers: Array[float] = []

## The direction steered away from all of the obstacles
var direction: Vector2


func _ready() -> void:
	_ray_directions.resize(number_of_rays)
	_ray_interests.resize(number_of_rays)
	_ray_dangers.resize(number_of_rays)


func _draw() -> void:
	if not enable_debug_display: return
	
	for i in range(number_of_rays):
		draw_line(Vector2.ZERO, _ray_directions[i] * _ray_interests[i] * sight_distance, Color.GREEN)
		draw_line(Vector2.ZERO, _ray_directions[i] * _ray_dangers[i] * sight_distance, Color.RED)
	
	draw_line(Vector2.ZERO, direction * 50, Color.BLUE, 2)
	draw_line(Vector2.ZERO, target_direction * 25, Color.YELLOW, 2)


# Public Methods


func get_direction_towards(_target_direction: Vector2) -> Vector2:
	target_direction = _target_direction
	update_direction()
	return direction


func get_direction_to(target_position: Vector2) -> Vector2:
	target_direction = global_position.direction_to(target_position)
	update_direction()
	return direction


## Update [member direction] to the preferred direction.
func update_direction() -> void:
	_distribute_rays()
	_set_interests()
	_set_danger()
	_set_direction()
	
	if enable_debug_display: queue_redraw()


# Private Methods


func _distribute_rays() -> void:
	for i in number_of_rays:
		var angle = (float(i) / float(number_of_rays)) * (PI*2)
		_ray_directions[i] = Vector2.RIGHT.rotated(angle)


func _set_interests() -> void:
	for i in number_of_rays:
		_ray_interests[i] = max(0, _ray_directions[i].rotated(rotation).dot(target_direction))


func _set_danger() -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	for i in number_of_rays:
		var params: = PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + _ray_directions[i].rotated(rotation) * _ray_interests[i] * sight_distance,
			collision_mask
		)
		
		params.collide_with_areas = collide_with_areas
		params.collide_with_bodies = collide_with_bodies
		params.hit_from_inside = false
		
		var result: Dictionary = space_state.intersect_ray(params)
		
		if result:
			_ray_dangers[i] = _ray_interests[i] - global_position.distance_to(result.position) / sight_distance
			_ray_dangers[i] += _ray_interests[i]
		else:
			_ray_dangers[i] = 0.0


func _set_direction() -> void:
	direction = Vector2.ZERO
	
	for i in range(number_of_rays):
		_ray_interests[i] -= _ray_dangers[i]
	
	for i in range(number_of_rays):
		direction += _ray_directions[i] * _ray_interests[i]
	
	direction = direction.normalized()
