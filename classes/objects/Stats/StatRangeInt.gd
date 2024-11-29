@tool
extends Node
class_name StatRangeInt

signal max_value_changed
signal min_value_changed
signal range_changed
signal value_changed
signal value_lowered
signal lowest
signal highest

@export var max_value: int = 0: set = set_max_value
@export var min_value: int = 0: set = set_min_value
var value: int = 0: set = set_value
var _suppress_event: bool = false

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	properties.append({
		"name": "value",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "%s,%s,0.5" % [
			min_value,
			max_value,
		]
	})
	
	return properties

func set_value(v: int) -> void:
	var old_value = value
	value = clampi(v, min_value, max_value)
	
	if _suppress_event:
		_suppress_event = false
		return

	value_changed.emit()
	
	if is_highest():
		highest.emit()
	if is_lowest():
		lowest.emit()
	if old_value > value:
		value_lowered.emit()

func set_max_value(v: int) -> void:
	max_value = v
	value = value
	notify_property_list_changed()
	max_value_changed.emit()
	range_changed.emit()

func set_min_value(v: int) -> void:
	min_value = v
	value = value
	notify_property_list_changed()
	min_value_changed.emit()
	range_changed.emit()

func is_highest() -> bool:
	return value >= max_value

func is_lowest() -> bool:
	return value <= min_value
