extends Resource
class_name HurtInfo2D


@export var last_health: int
@export var new_health: int

var hurtbox: Hurtbox2D


func with_hurtbox(value: Hurtbox2D) -> HurtInfo2D:
	hurtbox = value
	return self
