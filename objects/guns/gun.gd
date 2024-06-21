extends Node2D
class_name Gun

signal fired(bullets: Array[Node])
signal reloaded


## How many bullets will be fired per shot.
@export var bullets_per_shot: int = 1
## The spread the bullets will spawn with.
@export_range(0, 180.0) var spread: float = 0.0
## The resource that supplies the scenes that will be spawned.
@export var supplier: PackedSceneSupplier
## Whether this gun is an automatic.
@export var automatic: bool = false


@onready var ammo: StatRangeInt = $Ammo
@onready var fire_audio: AudioStreamPlayer = $FireAudio
@onready var reload_particles: CPUParticles2D = $ReloadParticles
@onready var fire_particles: CPUParticles2D = $End/FireParticles
@onready var spawn_marker: Marker2D = $End/SpawnMarker
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var left_handle: Marker2D = $Sprite2D/LeftHandle
@onready var right_handle: Marker2D = $Sprite2D/RightHandle

var _sprite_offset: float = 0.0


func _ready() -> void:
	assert(supplier, "%s is missing a `supplier`" % self)
	assert(ammo, "%s is missing `ammo`" % self)
	
	_sprite_offset = sprite.position.x


func _process(_delta: float) -> void:
	rotation = global_position.direction_to(get_global_mouse_position()).angle()
	
	sprite.flip_v = rotation < -PI/2.0 or rotation > PI/2.0
	
	sprite.position.x = (
		_sprite_offset - 4.0
		if Input.is_action_pressed(&"fire") else
		_sprite_offset
	)
	
	sprite.position.y = (
		-4.5
		if sprite.flip_v else
		0.0
	)
	
	if sprite.flip_v:
		left_handle.position.y = -abs(left_handle.position.y)
		right_handle.position.y = -abs(right_handle.position.y)
	else:
		left_handle.position.y = abs(left_handle.position.y)
		right_handle.position.y = -abs(right_handle.position.y)


func can_fire() -> bool:
	return not animation_player.is_playing()


func fire_action() -> bool:
	return (
		Input.is_action_just_pressed(&"fire")
		if not automatic else
		Input.is_action_pressed(&"fire")
	) and fire()


func fire() -> bool:
	if can_fire():
		force_fire()
		return true
	return false


func force_fire() -> void:
	fire_particles.emitting = true
	fire_audio.play()
	fired.emit(spawn(bullets_per_shot))
	
	ammo.value -= 1
	
	if ammo.value <= 0:
		animation_player.play(
			&"reload-left"
			if sprite.flip_v else
			&"reload-right"
		)
		
		animation_player.animation_finished.connect(func(_a):
			ammo.value = ammo.max_value, CONNECT_ONE_SHOT)
	else:
		animation_player.play(
			&"shoot-left"
			if sprite.flip_v else
			&"shoot-right"
		)


func spawn(amount: int) -> Array[Node]:
	assert(amount != 0, "%s no scenes will be spawned if `amount` is zero!" % self)
	assert(amount > -1, "%s `amount` cannot be a negative value!" % self)
	
	var spawns: Array[Node] = []
	
	for i in amount:
		spawns.append(spawn_single(amount, i))
	
	return spawns


func spawn_single(amount: int, idx: int) -> Node:
	var scene: PackedScene = supplier.supply()
	if scene == null:
		return
	
	var obj: Node = scene.instantiate()
	
	obj.set_meta(&"spawner_info", {
		&"global_rotation": spawn_marker.global_rotation + deg_to_rad(
			remap(idx + 0.5, 0, amount, -spread, spread)
			if bullets_per_shot > 1 else
			randf_range(-spread, spread)
		),
		&"global_position": spawn_marker.global_position,
	})
	
	get_tree().current_scene.add_child(obj)
	return obj
