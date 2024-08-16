extends Camera2D


var screen_shake_time: float = 0.0
var screen_shake_strength: float = 0.0
var rest_speed: float = 0.1


func _ready() -> void:
	Player.player.health.value_lowered.connect(func():
		zoom *= 1.02)
	
	Player.player.gun.fired.connect(func(bullets: Array[Node]):
		if Player.player.gun.shake_screen_on_fire:
			shake(0.15, 16.0)
		
		for b in bullets:
			var bullet: Bullet = b as Bullet
			if not bullet:
				continue
			
			bullet.killed.connect(func(e: Node):
				var enemy: Node2D = e as Node2D
				if not enemy:
					return
				
				var distance: float = Player.player.global_position.distance_squared_to(enemy.global_position)
				if (distance <= 12000.0):
					shake(0.15, 16.0)))


func _process(delta: float) -> void:
	zoom = zoom.lerp(Vector2(1, 1), 1.0 - pow(0.6, delta))
	
	if screen_shake_time > 0.0:
		screen_shake_time -= delta
		var desired_position: Vector2 = Vector2(randf_range(-screen_shake_strength, screen_shake_strength), randf_range(-screen_shake_strength, screen_shake_strength))
		offset = offset.lerp(desired_position, 1.0 - pow(0.1, delta))
	else:
		screen_shake_time = 0.0
		offset = offset.lerp(Vector2.ZERO, 1.0 - pow(rest_speed, delta))


func shake(time: float = 1.0, strength: float = 8.0) -> void:
	screen_shake_time = time
	screen_shake_strength = strength
