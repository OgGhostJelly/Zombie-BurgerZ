extends Control


func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if visible and SceneTransition.is_transitioning():
			return
		
		visible = not visible
		get_tree().paused = visible


func _on_resume_button_pressed() -> void:
	if SceneTransition.is_transitioning():
		return
	visible = false
	get_tree().paused = false


func _on_exit_button_pressed() -> void:
	PlayerData.data_save()
	SceneTransition.to_packed(preload("res://userinterfaces/main_menu/main_menu.tscn"))
