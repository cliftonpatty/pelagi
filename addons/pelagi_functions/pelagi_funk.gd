@tool
extends EditorPlugin

const mainPanel = preload("res://addons/pelagi_functions/update_fish.tscn")
var csv_scripts = load("res://addons/pelagi_functions/import_csv.gd")
var main_panel_instance : Control

func _enter_tree() -> void:
	main_panel_instance = mainPanel.instantiate()
	main_panel_instance.update_button_pressed.connect(update_with_csv)
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)

func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()
	pass

func _has_main_screen() -> bool:
	return true
	
func _make_visible(visible: bool) -> void:
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name() -> String:
	return "Pelagi Funk"


func _get_plugin_icon() -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")

func update_with_csv():
	csv_scripts.load_and_write()




