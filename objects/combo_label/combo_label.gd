extends Node2D
class_name ComboLabel


@export var text: String: set = set_text
@export var velocity: Vector2 = Vector2.UP * 64.0
@export var gravity: Vector2 = Vector2.DOWN * 256.0
@export var torque: float = PI
@export var power: int = 1

@onready var label: Label = $Label


func _ready() -> void:
	assert(label)
	
	velocity += Vector2(randf_range(-32.0, 32.0), randf_range(-32.0, 32.0))
	torque += randf_range(-PI/4, PI/4)
	
	if randf() > 0.5:
		velocity += (Vector2.UP + Vector2.RIGHT).normalized() * 64.0
		torque *= 1.0
	else:
		velocity += (Vector2.UP + Vector2.LEFT).normalized() * 64.0
		torque *= -1.0
	
	text = label.text


func _process(delta: float) -> void:
	modulate.a = lerpf(modulate.a, 0.0, 1.0 - pow(0.001, delta))
	velocity += gravity * delta
	global_position += velocity * delta
	rotation += torque * delta
	
	if modulate.a <= 0.0:
		queue_free()


func set_text(value: String) -> void:
	text = "+".repeat(power) + value
	if label: label.text = text


static func pierce(p_global_position: Vector2, p_power: int = 1) -> ComboLabel:
	var obj: ComboLabel = preload("res://objects/combo_label/pierce_label.tscn").instantiate()
	obj.power = p_power
	obj.global_position = p_global_position
	return obj

static func kill(p_global_position: Vector2, p_power: int = 1) -> ComboLabel:
	var obj: ComboLabel = preload("res://objects/combo_label/kill_label.tscn").instantiate()
	obj.power = p_power
	obj.global_position = p_global_position
	return obj

static func pierce_kill(p_global_position: Vector2, p_power: int = 1) -> ComboLabel:
	var obj: ComboLabel = preload("res://objects/combo_label/pierce_kill_label.tscn").instantiate()
	obj.power = p_power
	obj.global_position = p_global_position
	return obj
