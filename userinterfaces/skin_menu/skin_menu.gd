extends Control

signal selected_changed

@onready var skin_rack: HBoxContainer = $SkinRack
@onready var skin: VBoxContainer = $SkinRack/Skin

var selected: Player.PlayerType = Player.PlayerType.Normal: set = set_selected
var center: Vector2 = Vector2.ZERO


func _ready() -> void:
	for player in Player.PlayerType.values():
		var obj := skin.duplicate()
		var texture: TextureRect = obj.get_node(^"SkinTexture")
		texture.texture = Player.player_data[player].texture
		
		if Player.player_data[player].has("preview_offset"):
			var margin: MarginContainer = MarginContainer.new()
			#margin.add_theme_constant_override(&"margin_right", -Player.player_data[player].preview_offset.x)
			margin.add_theme_constant_override(&"margin_top", Player.player_data[player].preview_offset.y)
			texture.reparent(margin)
			obj.add_child(margin)
		
		skin_rack.add_child(obj)
	
	skin.queue_free()
	
	center = global_position


func set_selected(value: Player.PlayerType) -> void:
	selected = wrapi(value, 0, Player.PlayerType.size()) as Player.PlayerType
	var child := skin_rack.get_child(selected)
	var offset: Vector2 = center - child.global_position
	skin_rack.global_position += offset
	selected_changed.emit()


func _on_left_button_pressed() -> void:
	selected = (selected - 1) as Player.PlayerType


func _on_right_button_pressed() -> void:
	selected = (selected + 1) as Player.PlayerType
