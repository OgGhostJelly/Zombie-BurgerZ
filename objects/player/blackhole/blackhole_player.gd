extends Player


@export var blackhole_scene: PackedScene
var blackhole_count: int = 0


func _ready() -> void:
	super()
	assert(blackhole_scene)


func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed(&"special") and blackhole_count <= 1:
		energy_bar.use()


func _on_energy_bar_used() -> void:
	blackhole_count += 1
	var obj = blackhole_scene.instantiate()
	obj.global_position = get_global_mouse_position()
	get_parent().add_child(obj)
	obj.tree_exiting.connect(func():
		blackhole_count -= 1)
