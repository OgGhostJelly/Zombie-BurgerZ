extends Control


@onready var save: Control = $Save
@onready var export_file_dialog: FileDialog = $Save/Export/ExportFileDialog
@onready var import_file_dialog: FileDialog = $Save/Import/ImportFileDialog
@onready var import_confirmation_dialog: ConfirmationDialog = $Save/Import/ImportConfirmationDialog


func _ready() -> void:
	if OS.get_name() == "Web":
		save.visible = false


func _on_export_button_pressed() -> void:
	export_file_dialog.popup_centered()


func _on_export_file_dialog_file_selected(path: String) -> void:
	if not path.ends_with(".dat"):
		path += ".dat"
	
	var file := FileAccess.open(path, FileAccess.WRITE)
	PlayerData.save_to_file(file)


func _on_import_button_pressed() -> void:
	import_confirmation_dialog.popup_centered()


func _on_import_confirmation_dialog_confirmed() -> void:
	import_file_dialog.popup_centered()


func _on_import_file_dialog_file_selected(path: String) -> void:
	print(path)
	var file := FileAccess.open(path, FileAccess.READ)
	PlayerData.load_from_file(file)
