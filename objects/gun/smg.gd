extends Gun


@export var firing_recoil: float = 0.3
@export var recoil_decay: float = 1.0
@export_range(0, 180.0) var min_spread: float = 10.0
@export_range(0, 180.0) var max_spread: float = 20.0
var recoil: float = 0.0


func _ready() -> void:
	fired.connect(func(_a):
		recoil = minf(recoil + firing_recoil, 1.0))


func _process(delta: float) -> void:
	super(delta)
	
	recoil = maxf(recoil - delta * recoil_decay, 0.0)
	
	spread = lerpf(min_spread, max_spread, recoil)