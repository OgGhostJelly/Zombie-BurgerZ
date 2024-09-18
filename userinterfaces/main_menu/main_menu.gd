extends Control
class_name MainMenu


@onready var entrance_animation: AnimationPlayer = $Sign/Sign/EntranceAnimation
@onready var bop_animation: AnimationPlayer = $Sign/Sign/BopAnimation


func _ready() -> void:
	if UserData.main_menu_seen:
		entrance_animation.stop()
		bop_animation.play(&"bop")
		return
	UserData.main_menu_seen = true


var flickered: bool = false
func _on_flicker_timer_timeout() -> void:
	if not flickered:
		$FlickerAnimation.play(&"flicker_left")
		flickered = true
	elif randf() > 0.5:
		$FlickerAnimation.play(&"flicker_left")
	else:
		$FlickerAnimation.play(&"flicker_right")
	$FlickerTimer.wait_time = randf_range(3.0, 6.0)
