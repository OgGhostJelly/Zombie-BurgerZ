@tool
extends Resource
class_name AchievementData

enum Type {
	Normal,
	Lockable,
}

@export var name: String
@export var description: String
@export var texture: Texture2D

@export var type: Type = Type.Normal:
	set(value): type = value; notify_property_list_changed()

@export_group("Locked")
@export var locked_name: String
@export var locked_description: String
@export var locked_texture: Texture2D

static func create(props: Dictionary) -> AchievementData:
	var data = AchievementData.new()
	data.name = props.name
	data.description = props.description
	data.texture = props.texture
	
	if props.has("locked_name"): data.locked_name = props.locked_name
	if props.has("locked_description"): data.locked_description = props.locked_description
	if props.has("locked_texture"): data.locked_texture = props.locked_texture
	return data

func _validate_property(property: Dictionary) -> void:
	if property.name == &"locked_name" && type != Type.Lockable:
		property.usage ^= PROPERTY_USAGE_EDITOR
	if property.name == &"locked_description" && type != Type.Lockable:
		property.usage ^= PROPERTY_USAGE_EDITOR
	if property.name == &"locked_texture" && type != Type.Lockable:
		property.usage ^= PROPERTY_USAGE_EDITOR
