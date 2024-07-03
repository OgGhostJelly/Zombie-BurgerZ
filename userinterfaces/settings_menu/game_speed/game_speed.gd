extends VBoxContainer

signal pressed


@onready var slider: Slider = $Container/GameSpeedSlider
@onready var money_label: Label = $Container/MoneyTexture/Label
@onready var game_speed_label: Label = $Container/GameSpeedLabel


func _ready() -> void:
	slider.value = Settings.game_speed
	slider.max_value = Settings.GameSpeed.size() - 1
	update()


func update() -> void:
	money_label.text = "$x%.1f" % (1.0 + Settings.game_speed_money_bonus(Settings.game_speed))
	game_speed_label.text = "%s%%" % (100.0 + Settings.get_bonus_game_speed() * 100.0)


func _on_game_speed_slider_value_changed(value: float) -> void:
	Settings.game_speed = value as int as Settings.GameSpeed
	update()
	pressed.emit()
