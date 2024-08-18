extends Player


@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var dash_audio: AudioStreamPlayer = $DashAudio
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var speedlines: ColorRect = $CanvasLayer/Speedlines
var dash_ghost_time: float = 0.0
var dashing: bool = false
var last_animation: bool = false


func _ready() -> void:
	super()
	
	died.connect(func():
		FancyCamera2D.camera.stop_zoom())


func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed(&"special"):
		energy_bar.use()
	
	if dashing and velocity.length() > speed + 100.0:
		Engine.time_scale = (1.0 + Settings.get_bonus_game_speed()) / 2.0
		ghost_process(delta)
		if not last_animation:
			animation_player.play(&"start_slowmo")
			last_animation = true
	else:
		if dashing:
			FancyCamera2D.camera.stop_zoom()
		dashing = false
		Engine.time_scale = 1.0 + Settings.get_bonus_game_speed()
		if last_animation:
			animation_player.play(&"stop_slowmo")
			last_animation = false
	
	var desired_opacity: float = 0.0
	if dashing:
		desired_opacity = 1.0
	
	var speedlines_mat: ShaderMaterial = speedlines.material
	speedlines_mat.set_shader_parameter(&"opacity", lerpf(speedlines_mat.get_shader_parameter(&"opacity"), desired_opacity, delta * 2.0))



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
	FancyCamera2D.camera.do_zoom(Vector2.ONE * 1.25)
