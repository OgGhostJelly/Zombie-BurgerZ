@tool
extends Button
class_name FloatingMenuButton


@export var texture: Texture2D : set = set_texture
@export var float_speed: float = 0.002
@export var float_distance: float = 4.0

@onready var sprite: Sprite2D = $Sprite/Sprite2D
@onready var press_audio: AudioStreamPlayer = $PressAudio

var desired_scale: Vector2 = Vector2.ONE


func _ready() -> void:
	update_texture()


func _process(delta: float) -> void:
	sprite.scale = sprite.scale.lerp(desired_scale, 1.0 - 0.01 ** delta)
	sprite.position.y = sin(Time.get_ticks_msec() * float_speed) * float_distance


func _on_mouse_entered() -> void:
	desired_scale = Vector2.ONE * 1.2


func _on_mouse_exited() -> void:
	desired_scale = Vector2.ONE


func _on_pressed() -> void:
	sprite.scale = Vector2.ONE
	press_audio.play()


func update_texture() -> void:
	sprite.texture = texture
	custom_minimum_size = texture.get_size()


func set_texture(value: Texture2D) -> void:
	texture = value
	
	if is_node_ready():
		update_texture()
