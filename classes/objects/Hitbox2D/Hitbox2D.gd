extends Area2D
class_name Hitbox2D
## Hitbox can hit

signal hit(info: HurtInfo2D)


@export var info: HitInfo2D


func _init() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hurtbox: Hurtbox2D) -> void:
	if hurtbox == null:
		return
	
	if info == null:
		info = HitInfo2D.new()
	
	hit.emit(hurtbox._hurt(info.with_hitbox(self)))
