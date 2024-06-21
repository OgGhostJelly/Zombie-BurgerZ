extends HBoxContainer


@export var texture: Texture
@export var empty_texture: Texture

var ammo: StatRangeInt


func _ready() -> void:
	assert(texture, "Missing `texture`")
	assert(empty_texture, "Missing `empty_texture`")
	
	ammo = $"../Gun".ammo
	
	ammo.value_changed.connect(update_value)
	ammo.range_changed.connect(update_elements)
	
	update_elements()


func _process(_delta: float) -> void:
	var time: float = Time.get_ticks_msec()
	
	var children: Array[Node] = get_children()
	for i in children.size():
		children[i].position.y = sin(time * 0.01 + i * 2.0) \
			* ((float(ammo.max_value) - ammo.value) / ammo.max_value * 2.5 + 1.0)


func update_elements() -> void:
	for element in get_children():
		element.queue_free()
	
	for i in ammo.max_value:
		var obj: TextureRect = TextureRect.new()
		obj.flip_h = i % 2 == 0
		obj.flip_v = randf() > 0.8
		obj.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		obj.texture = texture if i < ammo.value else empty_texture
		add_child(obj)


func update_value() -> void:
	var children: Array[Node] = get_children()
	for i in children.size():
		children[i].texture = texture if i < ammo.value else empty_texture
