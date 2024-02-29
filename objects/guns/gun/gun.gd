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


@onready var fire_audio: AudioStreamPlayer = $FireAudio
@onready var reload_particles: CPUParticles2D = $ReloadParticles
@onready var fire_particles: CPUParticles2D = $FireParticles
@onready var spawn_marker: Marker2D = $SpawnMarker
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var handle: Marker2D = $Sprite2D/Handle


func _ready() -> void:
	assert(supplier, "%s is missing a `supplier`" % self)


func _process(_delta: float) -> void:
	rotation = global_position.direction_to(get_global_mouse_position()).angle()
	
	sprite.flip_v = rotation < -PI/2.0 or rotation > PI/2.0
	
	sprite.position.x = (
		16.0 - 4.0
		if Input.is_action_pressed(&"fire") else
		16.0
	)
	
	sprite.position.y = (
		-4.5
		if sprite.flip_v else
		0.0
	)
	
	if sprite.flip_v:
		handle.position.y = -abs(handle.position.y)
	else:
		handle.position.y = abs(handle.position.y)


func can_fire() -> bool:
	return not animation_player.is_playing()


func fire() -> bool:
	if can_fire():
		force_fire()
		return true
	return false


func force_fire() -> void:
	fire_particles.emitting = true
	fire_audio.play()
	fired.emit(spawn(bullets_per_shot))
	animation_player.play(&"reload")


func spawn(amount: int) -> Array[Node]:
	assert(amount != 0, "%s no scenes will be spawned if `amount` is zero!" % self)
	assert(amount > -1, "%s `amount` cannot be a negative value!" % self)
	
	var spawns: Array[Node] = []
	
	for i in amount:
		spawns.append(spawn_single(amount, i))
	
	return spawns


func spawn_single(_amount: int, _idx: int) -> Node:
	var scene: PackedScene = supplier.supply()
	if scene == null:
		return
	
	var obj: Node = scene.instantiate()
	
	obj.set_meta(&"spawner_info", {
		&"global_rotation": spawn_marker.global_rotation + deg_to_rad(randf_range(-spread, spread)),
		&"global_position": spawn_marker.global_position,
	})
	
	get_tree().current_scene.add_child(obj)
	return obj
