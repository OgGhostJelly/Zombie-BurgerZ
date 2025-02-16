extends VBoxContainer


@export var weapon_menu: Control

@onready var ammo_texture: TextureRect = $Stats/AmmoContainer/AmmoTexture
@onready var description: Label = $DescriptionLabel
@onready var ammo_label: Label = $Stats/AmmoContainer/AmmoLabel
@onready var pierce_label: Label = $Stats/PierceContainer/PierceLabel
@onready var spread_label: Label = $Stats/SpreadContainer/SpreadLabel


func _ready() -> void:
	weapon_menu.selected_changed.connect(update)
	update()


func update() -> void:
	var data: GunData = Gun.data[weapon_menu.selected]
	var gun: Gun = data.get_scene().instantiate()
	gun._ready()
	
	description.text = data.get_description()
	ammo_texture.texture = data.ammo_texture
	ammo_label.text = "%s" % gun.ammo.max_value
	
	var bullet: Node2D = gun.bullet_scene.instantiate()
	pierce_label.text = "%s" % bullet.pierce
	
	spread_label.text = "%s" % gun.spread
