extends HBoxContainer


@export var ammo: int = 0: set = set_ammo
@export var max_ammo: int = 5: set = set_max_ammo
@export var texture: Texture
@export var empty_texture: Texture


func _ready() -> void:
	assert(texture, "Missing `texture`")
	assert(empty_texture, "Missing `empty_texture`")
	update_elements()


func _process(_delta: float) -> void:
	var time: float = Time.get_ticks_msec()
	
	var children: Array[Node] = get_children()
	for i in children.size():
		children[i].position.y = sin(time * 0.01 + i * 2.0) \
			* ((float(max_ammo) - ammo) / max_ammo * 2.5 + 1.0)


func update_elements() -> void:
	for element in get_children():
		element.queue_free()
	
	for i in max_ammo:
		var obj: TextureRect = TextureRect.new()
		obj.flip_h = i % 2 == 0
		obj.flip_v = randf() > 0.8
		obj.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		obj.texture = texture if i < ammo else empty_texture
		add_child(obj)


func update_value() -> void:
	var children: Array[Node] = get_children()
	for i in children.size():
		children[i].texture = texture if i < ammo else empty_texture


func set_ammo(value: int) -> void:
	ammo = value
	update_value()


func set_max_ammo(value: int) -> void:
	max_ammo = value
	update_elements()
