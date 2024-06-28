extends Control


@onready var save: Control = $Save
@onready var export_file_dialog: FileDialog = $Save/Export/ExportFileDialog
@onready var import_file_dialog: FileDialog = $Save/Import/ImportFileDialog
@onready var import_confirmation_dialog: ConfirmationDialog = $Save/Import/ImportConfirmationDialog


func _on_export_button_pressed() -> void:
	if OS.get_name() == "Web":
		JavaScriptBridge.download_buffer(PlayerData.save_as_string().to_utf8_buffer(), "save.dat")
		return
	export_file_dialog.popup_centered()


func _on_export_file_dialog_file_selected(path: String) -> void:
	if not path.ends_with(".dat"):
		path += ".dat"
	
	var file := FileAccess.open(path, FileAccess.WRITE)
	PlayerData.save_to_file(file)


func _on_import_button_pressed() -> void:
	import_confirmation_dialog.popup_centered()


func _on_import_confirmation_dialog_confirmed() -> void:
	if OS.get_name() == "Web":
		JavaScriptBridge.get_interface("window")._godot_file_import_callback = _js_import_file_callback
		
		JavaScriptBridge.eval('
		let input = document.createElement("input")
		input.type = "file"
		input.accept = ".dat"
		input.onchange = () => {
			input.files[0].text().then((text) => {
				window._godot_file_import_text = text
				window._godot_file_import_callback()
			})
		}
		input.click()
		')
		return
	import_file_dialog.popup_centered()


var _js_import_file_callback = JavaScriptBridge.create_callback(_on_web_import_file)
func _on_web_import_file(_args) -> void:
	var text = JavaScriptBridge.get_interface("window")._godot_file_import_text
	PlayerData.load_from_string(text)
	PlayerData.data_save()


func _on_import_file_dialog_file_selected(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	PlayerData.load_from_file(file)
