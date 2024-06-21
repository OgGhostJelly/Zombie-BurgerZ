extends Control


@onready var label: Label = $Money/MoneyLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	PlayerData.money_changed.connect(func():
		animation_player.play(&"pickup")
		label.text = "%s" % PlayerData.money)
	label.text = "%s" % PlayerData.money
