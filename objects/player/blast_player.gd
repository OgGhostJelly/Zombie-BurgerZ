extends Player


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"special"):
		energy_bar.use()


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
