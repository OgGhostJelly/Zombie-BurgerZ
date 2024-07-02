extends VBoxContainer


@onready var slider: Slider = $VolumeSlider
@onready var audio: AudioStreamPlayer = $DragAudio
var manual: bool = false


func _ready() -> void:
	manual = true
	slider.value = AudioServer.get_bus_volume_db(0)
	manual = false


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_mute(0, value <= slider.min_value)
	if manual:
		return
	AudioServer.set_bus_volume_db(0, value)
	audio.play()
