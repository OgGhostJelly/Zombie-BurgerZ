extends Camera2D
class_name FancyCamera2D


static var camera: FancyCamera2D

var screen_shake_time: float = 0.0
var screen_shake_strength: float = 0.0
var rest_speed: float = 0.1


var desired_zoom: Vector2 = Vector2.ONE
var zoom_speed: float = 0.4


func _ready() -> void:
	camera = self
	
	Player.player.heartbeat_timer.timeout.connect(func():
		zoom *= 1.01)
	
	Player.player.health.value_lowered.connect(func():
		zoom *= 1.01)
	
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
				
				if not Player.player.gun.shake_screen_on_near_kill:
					return
				
				var distance: float = Player.player.global_position.distance_squared_to(enemy.global_position)
				if (distance <= 12000.0):
					shake(0.15, 16.0)))


func _process(delta: float) -> void:
	zoom = zoom.lerp(desired_zoom, 1.0 - pow(zoom_speed, delta))
	
	if screen_shake_time > 0.0:
		screen_shake_time -= delta
		var desired_position: Vector2 = Vector2(randf_range(-screen_shake_strength, screen_shake_strength), randf_range(-screen_shake_strength, screen_shake_strength))
		offset = offset.lerp(desired_position, 1.0 - pow(0.1, delta))
	else:
		screen_shake_time = 0.0
		offset = offset.lerp(Vector2.ZERO, 1.0 - pow(rest_speed, delta))


func do_zoom(p_desired_zoom: Vector2) -> void:
	desired_zoom = p_desired_zoom


func stop_zoom() -> void:
	desired_zoom = Vector2.ONE
	zoom_speed /= 2.0


func shake(time: float = 1.0, strength: float = 8.0) -> void:
	screen_shake_time = maxf(screen_shake_time, time)
	screen_shake_strength = maxf(screen_shake_strength, strength)
