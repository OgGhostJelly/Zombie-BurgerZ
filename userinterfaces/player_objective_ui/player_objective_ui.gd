extends Control


class Objective:
	var text: String
	var is_done: bool = false
	var sig: Signal
	
	func _init(p_sig: Signal, p_text: String) -> void:
		text = p_text
		sig = p_sig
		
		sig.connect(func(_a = null, _b = null, _c = null):
			is_done = true)
	
	func wait() -> void:
		if is_done:
			return
		await sig


signal finished

@export var player: Node2D

@onready var objective_label: Label = $ObjectiveLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var objectives: Array[Objective] = [
	Objective.new(player.moved, "Move with WASD"),
	Objective.new(player.gun.fired, "Shoot with LMB"),
	Objective.new(player.gun.reloaded, "Reload with 'R'"),
]

func _ready() -> void:
	for objective in objectives:
		if objective.is_done:
			continue
		
		objective_label.text = objective.text
		animation_player.play(&"show")
		await animation_player.animation_finished
		await objective.wait()
		animation_player.play(&"hide")
		await animation_player.animation_finished
	visible = false
	finished.emit()
