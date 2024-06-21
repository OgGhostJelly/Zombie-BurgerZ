extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stats_label: Label = $VBoxContainer/StatsLabel


func game_over(time: float, money_earnt: int, kill_count: int) -> void:
	get_tree().paused = true
	PlayerData.data_save()
	stats_label.text = stats_label.text % [time, money_earnt, kill_count]
	animation_player.play(&"show")


func _on_retry_button_pressed() -> void:
	SceneTransition.to_file(get_tree().current_scene.scene_file_path)


func _on_shop_button_pressed() -> void:
	SceneTransition.to_packed(preload("res://userinterfaces/shop_menu/shop_menu.tscn"))
