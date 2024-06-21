extends Node

signal money_changed


@export var money: int = 0: set = set_money


func set_money(value: int) -> void:
	money = value
	money_changed.emit()


func data_save() -> void:
	push_error("PlayerData.save: Not implemented!")


func data_load() -> void:
	push_error("PlayerData.load: Not implemented!")
