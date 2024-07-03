extends VBoxContainer


@onready var slider: Slider = $VolumeSlider
@onready var audio: AudioStreamPlayer = $DragAudio
var manual: bool = false


func _ready() -> void:
	manual = true
	slider.value = Settings.volume
	manual = false


func _on_volume_slider_value_changed(value: float) -> void:
	Settings.volume = value
	Settings.muted = value <= slider.min_value
	if manual:
		return
	audio.play()
