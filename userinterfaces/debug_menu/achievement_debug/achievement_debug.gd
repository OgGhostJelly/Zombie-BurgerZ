extends Control


@export var achievement_menu: AchievementMenu


func _ready() -> void:
	visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"info"):
		visible = not visible


func _on_unlock_pressed() -> void:
	Achievement.give_achievement(achievement_menu.selected)
	achievement_menu.selected = achievement_menu.selected


func _on_unlock_all_pressed() -> void:
	for ach in Achievement.AchievementType.values():
		Achievement.give_achievement(ach)
	achievement_menu.selected = achievement_menu.selected


func _on_lock_pressed() -> void:
	UserData.achievements.erase(achievement_menu.selected)
	achievement_menu.selected = achievement_menu.selected


func _on_lock_all_pressed() -> void:
	for ach in Achievement.AchievementType.values():
		UserData.achievements.erase(ach)
	achievement_menu.selected = achievement_menu.selected
