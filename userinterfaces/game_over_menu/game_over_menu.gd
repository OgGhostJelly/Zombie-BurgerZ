extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stats_label: Label = $Control/VBoxContainer/StatsLabel
@onready var challenges_label: Label = $Control/ChallengesLabel


func _ready() -> void:
	challenges_label.text = "Game speed %s%%\nNo moving %s\nGun sights %s" % [
		(100.0 + Challenge.get_bonus_game_speed() * 100.0),
		("enabled" if Challenge.no_move else "disabled"),
		("enabled" if Challenge.gun_sights else "disabled"),
	]


func game_over(time: float, money_earnt: int, kill_count: int) -> void:
	get_tree().paused = true
	PlayerData.data_save()
	stats_label.text = stats_label.text % [time, money_earnt, kill_count]
	animation_player.play(&"show")
	Engine.time_scale = 1.0


func _on_retry_button_pressed() -> void:
	SceneTransition.to_file(get_tree().current_scene.scene_file_path)


func _on_shop_button_pressed() -> void:
	SceneTransition.to_packed(preload("res://userinterfaces/shop_menu/shop_menu.tscn"))
