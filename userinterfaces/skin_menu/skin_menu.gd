extends Control

signal selected_changed

@onready var skin_rack: HBoxContainer = $SkinRack
@onready var skin: VBoxContainer = $SkinRack/Skin

var selected: Player.PlayerType = UserData.selected_skin
var marker_center: Vector2 = Vector2.ZERO
var rack_center: Vector2 = Vector2.ZERO


func _ready() -> void:
	marker_center = $SkinRack/Skin/HangerTexture/Marker.global_position
	rack_center = $SkinRack.global_position
	
	for player in Player.PlayerType.values():
		var obj := skin.duplicate()
		var texture: TextureRect = obj.get_node(^"SkinTexture")
		texture.texture = Player.player_data[player].texture
		
		if Player.player_data[player].has("preview_offset"):
			var margin: MarginContainer = MarginContainer.new()
			margin.add_theme_constant_override(&"margin_top", Player.player_data[player].preview_offset.y)
			texture.reparent(margin)
			obj.add_child(margin)
		
		skin_rack.add_child(obj)
	
	skin.free()
	
	selected = UserData.selected_skin


func _process(_delta: float) -> void:
	update_position()


func set_selected(value: Player.PlayerType) -> void:
	selected = wrapi(value, 0, Player.PlayerType.size()) as Player.PlayerType
	selected_changed.emit()


func update_position() -> void:
	var child := skin_rack.get_child(selected)
	var marker: Control = child.get_node(^"HangerTexture/Marker")
	var offset: Vector2 = marker_center - marker.global_position
	skin_rack.global_position += offset


func _on_left_button_pressed() -> void:
	set_selected((selected - 1) as Player.PlayerType)


func _on_right_button_pressed() -> void:
	set_selected((selected + 1) as Player.PlayerType)
