tool

extends EditorPlugin

const Exporter = preload("res://addons/godot-tools.gdrpg/dialog-system/dialog_node_exporter.gd")
const DialogTree = preload("res://addons/godot-tools.gdrpg/dialog-system/dialog_tree_node.gd")

var dock
var tree_path = "res://test.dt"

func _enter_tree():
	# Custom types
	add_custom_type("Database", "Node", preload("res://addons/godot-tools.gdrpg/dialog-system/database.gd"), null)
	add_custom_type("DialogTree", "Node", preload("res://addons/godot-tools.gdrpg/dialog-system/dialog_tree_node.gd"), null)
	
	# Dialog Editor
	dock = preload("res://addons/godot-tools.gdrpg/dialog-system/UI/DialogEditorPanel.tscn").instance()
	add_control_to_bottom_panel(dock, "Dialog Editor")
	
func _exit_tree():
	# Dialog Editor
	remove_control_from_bottom_panel(dock)
	dock.free()
	
	# Custom Types
	remove_custom_type("DialogTree")
	remove_custom_type("Database")

func save_external_data():
	dock.editor.save()

