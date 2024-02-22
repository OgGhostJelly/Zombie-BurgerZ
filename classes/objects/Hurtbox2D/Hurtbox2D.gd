extends Area2D
class_name Hurtbox2D
## Hurtbox can hurt

signal hurt(info: HitInfo2D)


@export var info: HurtInfo2D


func _hurt(hit_info: HitInfo2D) -> HurtInfo2D:
	hurt.emit(hit_info)
	
	if info == null:
		info = HurtInfo2D.new()
	
	return info.with_hurtbox(self)
