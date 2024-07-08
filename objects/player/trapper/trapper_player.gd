extends Player


@export var trap_limit: int = 3
@onready var place_timer: Timer = $PlaceTimer
@onready var place_audio: AudioStreamPlayer = $PlaceAudio
var trap_count: int = 0


func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed(&"special") and trap_count < 3:
		energy_bar.use()


func _on_energy_bar_used() -> void:
	trap_count += 1
	var obj: Node2D = preload("res://objects/player/trapper/trap/trap.tscn").instantiate()
	obj.global_position = global_position
	get_parent().add_child(obj)
	obj.died.connect(func():
		trap_count -= 1)
	place_timer.start()
	place_audio.play()


func get_input_vector() -> Vector2:
	if place_timer.is_stopped():
		return super()
	return Vector2.ZERO
