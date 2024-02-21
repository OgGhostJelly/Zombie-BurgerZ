extends CharacterBody2D
class_name Character2D

signal max_health_changed
signal health_changed
signal died

## The maximum health the character can have.
@export var max_health: int = 5: set = set_max_health
## The current amount of health the character has.
@export var health: int = 5: set = set_health


## A virtual function that will get called before this character dies.
func _die() -> void:
	pass


func set_max_health(value: int) -> void:
	max_health = value
	health = health
	max_health_changed.emit()

func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	health_changed.emit()
	
	if health <= 0:
		_die()
		died.emit()
