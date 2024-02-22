extends Node
class_name StatsTracker


@export var player: Player

var accuracy_score: float = 1.0:
	set(value): accuracy_score = clampf(value, 0.0, 1.0)
var accuracy_adjustment_rate: float = 0.05
var accuracy_miss_penalty: float = 0.2


func _ready() -> void:
	await player.ready
	player.gun.fired.connect(_on_player_gun_fired)


func _on_player_gun_fired(bullets: Array[Node]) -> void:
	for node in bullets:
		var bullet: Hitbox2D = node as Hitbox2D
		if bullet == null:
			continue
		
		accuracy_score -= accuracy_miss_penalty
		
		bullet.hit.connect(func(_info) -> void:
			accuracy_score += accuracy_miss_penalty)
