extends Player


@onready var dash_timer: Timer = $DashTimer


func _process(_delta: float) -> void:
	var input_vector := get_input_vector()
	
	if Input.is_action_just_pressed(&"special") and not input_vector.is_zero_approx():
		energy_bar.use()


func is_invincible() -> bool:
	return super() or not dash_timer.is_stopped()


func _on_energy_bar_used() -> void:
	var input_vector := get_input_vector()
	
	if input_vector.is_zero_approx():
		return
	
	velocity = input_vector * 400.0
	dash_timer.start()
