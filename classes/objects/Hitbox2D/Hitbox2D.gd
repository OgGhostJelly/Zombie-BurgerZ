extends Area2D
class_name Hitbox2D
## Hitbox can hit

signal hit(info: HurtInfo2D)


@export var root: Node
@export var hit_info: HitInfo2D


func _init() -> void:
	area_entered.connect(_on_area_entered)


func _ready() -> void:
	assert(root)


func _on_area_entered(hurtbox: Hurtbox2D) -> void:
	if hurtbox == null:
		return
	
	if hit_info == null:
		hit_info = HitInfo2D.new()
	
	hit.emit(hurtbox._hurt(hit_info.with_hitbox(self)))
