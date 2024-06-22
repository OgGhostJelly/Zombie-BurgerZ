extends Area2D
class_name Hurtbox2D
## Hurtbox can hurt

signal hurt(info: HitInfo2D)


@export var root: Node
@export var hurt_info: HurtInfo2D


func _ready() -> void:
	assert(root)


func _hurt(hit_info: HitInfo2D) -> HurtInfo2D:
	hurt.emit(hit_info)
	
	if hurt_info == null:
		hurt_info = HurtInfo2D.new()
	
	return hurt_info.with_hurtbox(self)
