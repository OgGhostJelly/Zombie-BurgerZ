extends VBoxContainer

signal pressed


@onready var slider: Slider = $Container/GameSpeedSlider
@onready var money_label: Label = $Container/MoneyTexture/Label
@onready var game_speed_label: Label = $Container/GameSpeedLabel


func _ready() -> void:
	slider.value = Challenge.game_speed
	slider.max_value = Challenge.GameSpeed.size() - 1
	update()


func update() -> void:
	money_label.text = "$x%.1f" % (1.0 + Challenge.game_speed_money_bonus(Challenge.game_speed))
	game_speed_label.text = "%s%%" % (100.0 + Challenge.get_bonus_game_speed() * 100.0)


func _on_game_speed_slider_value_changed(value: float) -> void:
	Challenge.game_speed = value as int as Challenge.GameSpeed
	print(Challenge.game_speed)
	update()
	pressed.emit()
