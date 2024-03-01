extends HBoxContainer


@export var health: StatRangeInt
@export var texture: Texture
@export var empty_texture: Texture


func _ready() -> void:
	assert(texture, "Missing `texture`")
	assert(empty_texture, "Missing `empty_texture`")
	
	health.value_changed.connect(update_value)
	health.range_changed.connect(update_elements)
	
	update_elements()


func _process(_delta: float) -> void:
	var time: float = Time.get_ticks_msec()
	
	var children: Array[Node] = get_children()
	for i in children.size():
		children[i].position.y = sin(time * 0.01 + i * 2.0) \
			* ((float(health.max_value) - health.value) / health.max_value * 2.5 + 1.0)


func update_elements() -> void:
	for element in get_children():
		element.queue_free()
	
	for i in health.max_value:
		var obj: TextureRect = TextureRect.new()
		obj.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		obj.texture = texture if i < health.value else empty_texture
		add_child(obj)


func update_value() -> void:
	var children: Array[Node] = get_children()
	for i in children.size():
		children[i].texture = texture if i < health.value else empty_texture
