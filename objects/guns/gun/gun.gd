extends Node2D

signal ammo_changed
signal max_ammo_changed


## How many bullets will be fired per shot.
@export var bullets_per_shot: int = 1
## How many bullets will be reloaded when a reload occurs.
@export var bullets_per_reload: int = 1
## The spread the bullets will spawn with.
@export_range(0, 180.0) var spread: float = 0.0
## The resource that supplies the scenes that will be spawned.
@export var supplier: PackedSceneSupplier
## The maximum ammo the gun can store.
@export var max_ammo: int = 5: set = set_max_ammo

var ammo: int = max_ammo: set = set_ammo

@onready var empty_audio: AudioStreamPlayer = $EmptyAudio
@onready var shoot_audio: AudioStreamPlayer = $ShootAudio
@onready var reload_audio: AudioStreamPlayer = $ReloadAudio
@onready var reload_particles: CPUParticles2D = $ReloadParticles
@onready var shoot_particles: CPUParticles2D = $ShootParticles
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	assert(supplier, "%s is missing a `supplier`" % self)


func _process(_delta: float) -> void:
	rotation = global_position.direction_to(get_global_mouse_position()).angle()
	
	sprite.flip_v = rotation < -PI/2.0 or rotation > PI/2.0
	
	sprite.position.x = (
		16.0 - 4.0
		if Input.is_action_pressed(&"shoot") else
		16.0
	)
	
	sprite.position.y = (
		-4.5
		if sprite.flip_v else
		0.0
	)


func can_shoot() -> bool:
	return ammo > 0


func shoot() -> void:
	if can_shoot():
		force_shoot()
	else:
		empty_audio.play()


func force_shoot() -> void:
	shoot_particles.emitting = true
	shoot_audio.play()
	var amount: int = min(bullets_per_shot, ammo)
	ammo -= amount
	spawn(amount)


func can_reload() -> bool:
	return ammo < max_ammo


func reload() -> void:
	if can_reload():
		force_reload()


func force_reload() -> void:
	reload_particles.emitting = true
	reload_audio.play()
	ammo += bullets_per_reload


func spawn(amount: int) -> void:
	assert(amount != 0, "%s no scenes will be spawned if `amount` is zero!" % self)
	assert(amount > -1, "%s `amount` cannot be a negative value!" % self)
	
	for i in amount:
		spawn_single(amount, i)


func spawn_single(_amount: int, _idx: int) -> void:
	var scene: PackedScene = supplier.supply()
	if scene == null:
		return
	
	var obj = scene.instantiate()
	if obj is Node2D:
		obj.transform = transform
	
	
	
	obj.set_meta(&"spawner_info", {
		&"global_rotation": global_rotation + deg_to_rad(randf_range(-spread, spread)),
		&"global_position": global_position,
	})
	get_tree().current_scene.add_child(obj)


func set_ammo(value: int) -> void:
	ammo = clampi(value, 0, max_ammo)
	ammo_changed.emit()


func set_max_ammo(value: int) -> void:
	max_ammo = value
	max_ammo_changed.emit()