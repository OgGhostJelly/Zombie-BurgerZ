extends Resource

signal max_health_changed
signal max_ammo_changed
signal health_changed
signal ammo_changed

@export var max_health: int = 5: set = set_max_health
@export var max_ammo: int = 5: set = set_max_ammo
@export var health: int = 5: set = set_health
@export var ammo: int = 5: set = set_ammo


func set_max_health(value: int) -> void:
	max_health = value
	max_health_changed.emit()

func set_max_ammo(value: int) -> void:
	max_ammo = value
	max_ammo_changed.emit()

func set_health(value: int) -> void:
	health = value
	health_changed.emit()

func set_ammo(value: int) -> void:
	ammo = value
	ammo_changed.emit()
