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

@export var player_path: NodePath
var player: Player

@onready var objective_label: Label = $ObjectiveLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	player = get_node(player_path)
	
	var objectives: Array[Objective] = []
	
	if not Challenge.no_move:
		objectives.append(Objective.new(player.moved, "Move with WASD"))
	
	objectives.append(Objective.new(player.gun.fired, "Shoot with LMB"))
	
	if not player.energy_bar.disabled:
		objectives.append(Objective.new(player.energy_bar.used, "Ability with RMB"))
	
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
