extends CharacterBody2D
class_name Character2D

signal died

@export var health: StatRangeInt

func _ready() -> void:
	health.lowest.connect(func():
		_die()
		died.emit())


func _die() -> void:
	pass
