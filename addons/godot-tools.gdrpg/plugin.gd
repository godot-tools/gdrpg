tool

extends EditorPlugin

const DialogTree = preload("res://addons/godot-tools.gdrpg/dialog-system/dialog_tree_node.gd")

var rpgPlugin
var gizmo
var tree_path = "res://test.dt"

func _enter_tree():
	# Custom types
	add_custom_type("Database", "Node", preload("res://addons/godot-tools.gdrpg/dialog-system/database.gd"), null)
	add_custom_type("DialogTree", "Node", preload("res://addons/godot-tools.gdrpg/dialog-system/dialog_tree_node.gd"), null)
	add_custom_type("SQLiteDB", "Node", preload("res://addons/godot-tools.gdrpg/sqlite/sqlitedb.gd"), null)
	
	# Dialog Editor
	rpgPlugin = preload("res://addons/godot-tools.gdrpg/RPGPlugin.tscn").instance()
	rpgPlugin.hide()
	get_editor_interface().get_editor_viewport().add_child(rpgPlugin)
	#add_control_to_container(CONTAINER_TOOLBAR, rpgPlugin)
	#get_editor_interface().get_editor_viewport().add_child(rpgPlugin)
	#add_control_to_bottom_panel(dock, "Dialog Editor")
	_create_gizmo()
	
func _exit_tree():
	# Dialog Editor
	remove_control_from_container(CONTAINER_TOOLBAR, gizmo)
	get_editor_interface().get_editor_viewport().remove_child(rpgPlugin)
	#get_editor_interface().get_editor_viewport().remove_child(rpgPlugin)
	#remove_control_from_container(CONTAINER_TOOLBAR, rpgPlugin)
	#remove_control_from_bottom_panel(rpgPlugin)
	rpgPlugin.free()
	
	# Custom Types
	remove_custom_type("SQLiteDB")
	remove_custom_type("DialogTree")
	remove_custom_type("Database")

func _create_gizmo():
	gizmo = Button.new()
	gizmo.text = get_plugin_name()
	add_control_to_container(CONTAINER_TOOLBAR, gizmo)

func make_visible(visible):
	if visible:
		rpgPlugin.show()
	else:
		rpgPlugin.hide()

func save_external_data():
	rpgPlugin.get_node("TabContainer/Dialog Editor/DialogEditorPanel").editor.save()

func has_main_screen():
	return true
	
func get_plugin_name():
	return "RPG"

