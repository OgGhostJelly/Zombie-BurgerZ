@tool
extends CircularProgressBar
class_name EnergyBar

signal used

@export var player: Player
@export var energy_per_kill: float = 0.0
@export var energy_per_pierce: float = 0.0
@export var energy_per_piercekill: float = 0.0
@export var regeneration_speed: float = 0.0
@export var disabled: bool = false
@export var cost: float = 1.0
@export var require_full: bool = true


func _ready() -> void:
	if not player.is_node_ready():
		await player.ready
	
	# player.gun doesn't exist while in the editor because Player is not a tool script.
	# and scripts running in the editor can only access properties from scripts also running in the editor.
	if not Engine.is_editor_hint():
		player.gun.hit.connect(_on_gun_hit)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if regeneration_speed > 0.0:
		value -= (1.0 / regeneration_speed) * delta


func _on_gun_hit(bullet: Bullet, info: HurtInfo2D) -> void:
	var power: int = bullet.history.size() - 1
	
	if info.hurtbox.root.health.is_lowest():
		if bullet.history.size() > 1 and energy_per_piercekill:
			get_tree().current_scene.add_child(
				ComboLabel.pierce_kill(bullet.global_position, power))
			value -= energy_per_piercekill * power
		elif energy_per_kill > 0.0:
			get_tree().current_scene.add_child(ComboLabel.kill(bullet.global_position))
			value -= energy_per_kill
	elif bullet.history.size() > 1 and energy_per_pierce > 0.0:
		get_tree().current_scene.add_child(ComboLabel.pierce(bullet.global_position, power))
		value -= energy_per_pierce * power


func can_use() -> bool:
	if require_full:
		return value <= 0.0
	else:
		return value < 1.0 - cost + 0.001


func use() -> bool:
	if can_use():
		force_use()
		return true
	return false


func force_use() -> void:
	value += cost
	used.emit()


func set_value(v: float) -> void:
	super(v)
	value = clampf(value, 0.0, 1.0)
	if is_zero_approx(value):
		value = 0.0
