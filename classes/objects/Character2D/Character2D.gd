extends CharacterBody2D
class_name Character2D

signal died

@onready var health: StatRangeInt = $Health

func _ready() -> void:
	assert(health, "`Character2D` needs a `StatRangeInt` named `Health` as its child or it will not work.")
	
	health.lowest.connect(func():
		_die()
		died.emit())


func _die() -> void:
	pass
