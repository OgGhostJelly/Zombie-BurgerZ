extends Resource
class_name HitInfo2D


var hitbox: Hitbox2D


func with_hitbox(value: Hitbox2D) -> HitInfo2D:
	hitbox = value
	return self
