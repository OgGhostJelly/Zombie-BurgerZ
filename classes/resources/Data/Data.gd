@tool
extends Resource
class_name Data

@export var _scene: PackedScene
@export var _texture: Texture2D
@export_multiline var _description: String

enum Type {
	Purchaseable,
	Unlockable
}

@export var type: Type = Type.Purchaseable:
	set(value): type = value; notify_property_list_changed()

@export_group("Purchaseable")
@export var _cost: int = 0
@export_group("Unlockable")
@export var _use_locked_description: bool = true
@export_multiline var _locked_description: String

func _validate_property(property: Dictionary) -> void:
	if property.name == &"_cost" && type != Type.Purchaseable:
		property.usage ^= PROPERTY_USAGE_EDITOR
	if property.name == &"_use_locked_description" && type != Type.Unlockable:
		property.usage ^= PROPERTY_USAGE_EDITOR
	if property.name == &"_locked_description" && type != Type.Unlockable:
		property.usage ^= PROPERTY_USAGE_EDITOR

func get_texture() -> Texture2D:
	return _texture

func get_scene() -> PackedScene:
	return _scene

func get_cost() -> int:
	if type != Type.Purchaseable:
		push_warning("Trying to get the cost of a non-purchaseable item.")
	return _cost

func get_description() -> String:
	return _description

func get_locked_description() -> String:
	if type == Type.Unlockable && _use_locked_description:
		return _locked_description
	else:
		return _description
