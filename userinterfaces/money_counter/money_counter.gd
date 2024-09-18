extends Control


@onready var label: Label = $Money/MoneyLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	UserData.money_changed.connect(func():
		animation_player.play(&"pickup")
		label.text = "%s" % UserData.money)
	label.text = "%s" % UserData.money
