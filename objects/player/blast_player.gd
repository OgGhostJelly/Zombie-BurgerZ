extends Player


@onready var blur_effect: ColorRect = $CanvasLayer/BlurEffect


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"special"):
		energy_bar.use()
	
	(blur_effect.material as ShaderMaterial).set_shader_parameter(&"lod", clampf(remap(health.value, health.min_value, health.max_value, 1.0, 0.0), 0.0, 1.0) * 3.0)


func _on_energy_bar_used() -> void:
	var amount: int = 16
	for i in amount:
		gun.spawn_single(amount, i, global_position, TAU * (float(i) / amount))
	await get_tree().create_timer(0.2).timeout
	for i in amount:
		gun.spawn_single(amount, i, global_position, TAU * (float(i) / amount))
	await get_tree().create_timer(0.2).timeout
	for i in amount:
		gun.spawn_single(amount, i, global_position, TAU * (float(i) / amount))
