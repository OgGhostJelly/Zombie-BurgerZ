extends Node2D


@export var gun: Gun
@export var enabled: bool = true
var _cached_bullet: Bullet


func _ready() -> void:
	enabled = Settings.gun_sights
	visible = enabled
	
	_cached_bullet = gun.bullet_scene.instantiate()


func _process(_delta: float) -> void:
	if enabled:
		queue_redraw()


func _draw() -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	if not gun.deterministic_spread:
		var half_spread: float = deg_to_rad(gun.spread / 2.0)
		var samples: int = 30
	
		var points: PackedVector2Array = []
		points.append(Vector2.ZERO)
		
		for idx in samples:
			var angle: float = remap(idx, 0, samples - 1, -half_spread, half_spread)
			var ray_end: Vector2 = Vector2.RIGHT.rotated(angle) * 640.0
			var color: Color = Color(0.0, 0.0, 1.0, 0.5)
			
			var results: Array[Dictionary] = []
			simulate_shot(results, space_state, global_position, to_global(ray_end), _cached_bullet.pierce, [])
			
			if results[0]:
				if results[-1]: ray_end = to_local(results[-1].position)
				color = Color(1.0, 0.0, 0.0, 0.5)
			
			for result in results:
				if not result:
					continue
				draw_circle(to_local(result.position), 2.0, color)
			
			points.append(ray_end)
		
		points.append(Vector2.ZERO)
		draw_polyline(points, Color(0.0, 0.0, 1.0, 0.5))
		return
	
	for idx in gun.bullets_per_shot:
		var angle: float = deg_to_rad(remap(idx + 0.5, 0, gun.bullets_per_shot, -gun.spread, gun.spread))
		var ray_end: Vector2 = Vector2.RIGHT.rotated(angle) * 640.0
		var color: Color = Color(0.0, 0.0, 1.0, 0.5)
		
		var results: Array[Dictionary] = []
		simulate_shot(results, space_state, global_position, to_global(ray_end), _cached_bullet.pierce, [])
		
		if results[0]:
			if results[-1]: ray_end = to_local(results[-1].position)
			color = Color(1.0, 0.0, 0.0, 0.5)
		
		for result in results:
			if not result:
				continue
			draw_circle(to_local(result.position), 8.0, color)
		
		draw_line(Vector2.ZERO, ray_end, color)


func simulate_shot(results: Array[Dictionary], space_state: PhysicsDirectSpaceState2D, from: Vector2, to: Vector2, pierce: int, exclude: Array[RID]):
	var params: = PhysicsRayQueryParameters2D.create(from, to, _cached_bullet.collision_mask, exclude)
	var result: Dictionary = space_state.intersect_ray(params)
	
	if not result:
		results.append({})
		return
	results.append(result)
	exclude.append(result.rid)
	
	var collider = result.collider
	
	pierce -= collider.skin_pierce_strength
	
	if pierce <= 0:
		return
	
	return simulate_shot(results, space_state, result.position, to, pierce, exclude)
