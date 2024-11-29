extends Control


@export var achievement_menu: AchievementMenu


func _ready() -> void:
	visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		visible = not visible


func _on_unlock_pressed() -> void:
	Achievement.give_achievement(Achievement.data.keys()[achievement_menu.selected_index])
	achievement_menu.selected_index = achievement_menu.selected_index


func _on_unlock_all_pressed() -> void:
	for ach in Achievement.data:
		Achievement.give_achievement(ach)
	achievement_menu.selected_index = achievement_menu.selected_index


func _on_lock_pressed() -> void:
	UserData.achievements.erase(Achievement.data.keys()[achievement_menu.selected_index])
	achievement_menu.selected_index = achievement_menu.selected_index


func _on_lock_all_pressed() -> void:
	for ach in Achievement.data:
		UserData.achievements.erase(ach)
	achievement_menu.selected_index = achievement_menu.selected_index
