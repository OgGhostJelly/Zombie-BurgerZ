extends CPUParticles2D
class_name OneshotParticles


func _ready() -> void:
	one_shot = true
	finished.connect(func():
		queue_free())
