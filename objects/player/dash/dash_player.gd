extends Player


@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var dash_audio: AudioStreamPlayer = $DashAudio
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var dash_ghost_time: float = 0.0
var dashing: bool = false
var last_animation: bool = false


func _ready() -> void:
	super()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"special"):
		energy_bar.use()
	
	if dashing and velocity.length() > speed + 100.0:
		Engine.time_scale = (1.0 + Settings.bonus_game_speed) / 2.0
		ghost_process(delta)
		if not last_animation:
			animation_player.play(&"start_slowmo")
			last_animation = true
	else:
		dashing = false
		Engine.time_scale = 1.0 + Settings.bonus_game_speed
		if last_animation:
			animation_player.play(&"stop_slowmo")
			last_animation = false
	


func ghost_process(delta: float) -> void:
	dash_ghost_time += delta
	if dash_ghost_time >= 0.025:
		var obj: Node2D = preload("res://objects/player/dash/dash_debris/dash_debris.tscn").instantiate()
		obj.global_position = global_position
		get_parent().add_child(obj)
		dash_ghost_time -= 0.025


func _on_energy_bar_used() -> void:
	var input_vector := global_position.direction_to(get_global_mouse_position())
	
	if input_vector.is_zero_approx():
		return
	
	velocity = input_vector * 400.0
	particles.emitting = true
	dash_audio.play()
	dashing = true
