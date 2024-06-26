extends Control


@export var acheivement_menu: AcheivementMenu


func _ready() -> void:
	visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		visible = not visible


func _on_unlock_pressed() -> void:
	Acheivement.give_acheivement(acheivement_menu.selected)
	acheivement_menu.selected = acheivement_menu.selected


func _on_unlock_all_pressed() -> void:
	for ach in Acheivement.AcheivementType.values():
		Acheivement.give_acheivement(ach)
	acheivement_menu.selected = acheivement_menu.selected
