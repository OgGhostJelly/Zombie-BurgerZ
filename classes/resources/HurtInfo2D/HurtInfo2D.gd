extends Resource
class_name HurtInfo2D


var hurtbox: Hurtbox2D


func with_hurtbox(value: Hurtbox2D) -> HurtInfo2D:
	hurtbox = value
	return self
