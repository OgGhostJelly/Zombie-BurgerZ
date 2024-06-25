extends Player


@onready var particles: CPUParticles2D = $CPUParticles2D


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"special"):
		energy_bar.use()


func _on_energy_bar_used() -> void:
	var input_vector := global_position.direction_to(get_global_mouse_position())
	
	if input_vector.is_zero_approx():
		return
	
	velocity = input_vector * -400.0
	particles.emitting = true
	
	for i in 10:
		var obj: Node2D = preload("res://objects/player/dash/dash_debris/dash_debris.tscn").instantiate()
		obj.global_position = global_position
		get_parent().add_child(obj)
		await get_tree().create_timer(0.025).timeout
