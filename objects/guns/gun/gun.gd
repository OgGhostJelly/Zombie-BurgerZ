extends Node2D

signal ammo_changed
signal max_ammo_changed
signal fired
signal reloaded


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
@onready var fire_audio: AudioStreamPlayer = $FireAudio
@onready var reload_audio: AudioStreamPlayer = $ReloadAudio
@onready var reload_particles: CPUParticles2D = $ReloadParticles
@onready var fire_particles: CPUParticles2D = $FireParticles
@onready var spawn_marker: Marker2D = $SpawnMarker
@onready var sprite: Sprite2D = $Sprite2D


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


func can_fire() -> bool:
	return ammo > 0


func fire() -> void:
	if can_fire():
		force_fire()
	else:
		empty_audio.play()


func force_fire() -> void:
	fire_particles.emitting = true
	fire_audio.play()
	var amount: int = min(bullets_per_shot, ammo)
	ammo -= amount
	spawn(amount)
	fired.emit()


func can_reload() -> bool:
	return ammo < max_ammo


func reload() -> void:
	if can_reload():
		force_reload()


func force_reload() -> void:
	reload_particles.emitting = true
	reload_audio.play()
	ammo += bullets_per_reload
	reloaded.emit()


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
	
	obj.set_meta(&"spawner_info", {
		&"global_rotation": spawn_marker.global_rotation + deg_to_rad(randf_range(-spread, spread)),
		&"global_position": spawn_marker.global_position,
	})
	
	get_tree().current_scene.add_child(obj)


func set_ammo(value: int) -> void:
	ammo = clampi(value, 0, max_ammo)
	ammo_changed.emit()


func set_max_ammo(value: int) -> void:
	max_ammo = value
	max_ammo_changed.emit()
