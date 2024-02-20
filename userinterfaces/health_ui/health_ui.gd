extends HBoxContainer


@export var health: int = 0: set = set_health
@export var max_health: int = 5: set = set_max_health
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
			* ((float(max_health) - health) / max_health * 2.5 + 1.0)


func update_elements() -> void:
	for element in get_children():
		element.queue_free()
	
	for i in max_health:
		var obj: TextureRect = TextureRect.new()
		obj.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		obj.texture = texture if i < health else empty_texture
		add_child(obj)


func update_value() -> void:
	var children: Array[Node] = get_children()
	for i in children.size():
		children[i].texture = texture if i < health else empty_texture


func set_health(value: int) -> void:
	health = value
	update_value()


func set_max_health(value: int) -> void:
	max_health = value
	update_elements()
