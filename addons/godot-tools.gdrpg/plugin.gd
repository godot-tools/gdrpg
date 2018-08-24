tool

extends EditorPlugin

const DialogTree = preload("res://addons/godot-tools.gdrpg/dialog-system/dialog_tree_node.gd")

var rpgPlugin
var gizmo
var tree_path = "res://test.dt"

func _enter_tree():
	# Custom types
	# SQLite
	add_custom_type("SQLite", "Node", preload("res://addons/godot-tools.gdrpg/lib/sqlite.gd"), null)
	
	# Dialog
	add_custom_type("DialogTree", "Node", preload("res://addons/godot-tools.gdrpg/dialog-system/dialog_tree_node.gd"), null)
	
	# AI
	add_custom_type("Blackboard", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/blackboard.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/blackboard.png"))
	add_custom_type("BehaviorTree", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/behavior_tree.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/tree.png"))
	add_custom_type("Selector", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/selector.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/selector.png"))
	add_custom_type("Sequence", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/sequence.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/sequence.png"))
	add_custom_type("Inverter", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/inverter.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/inverter.png"))
	add_custom_type("Repeater", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/repeater.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/repeater.png"))
	add_custom_type("Succeeder", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/succeeder.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/succeeder.png"))
	
	# Dialog Editor
	rpgPlugin = preload("res://addons/godot-tools.gdrpg/RPGPlugin.tscn").instance()
	rpgPlugin.hide()
	get_editor_interface().get_editor_viewport().add_child(rpgPlugin)
	_create_gizmo()
	
func _exit_tree():
	# Dialog Editor
	remove_control_from_container(CONTAINER_TOOLBAR, gizmo)
	get_editor_interface().get_editor_viewport().remove_child(rpgPlugin)
	rpgPlugin.free()
	
	# Custom Types
	# AI
	remove_custom_type("Blackboard")
	remove_custom_type("BehaviorTree")
	remove_custom_type("Selector")
	remove_custom_type("Sequence")
	remove_custom_type("Inverter")
	remove_custom_type("Repeater")
	remove_custom_type("Succeeder")
	
	# Dialog
	remove_custom_type("DialogTree")
	
	# SQLite
	remove_custom_type("SQLite")

func _create_gizmo():
	gizmo = Button.new()
	gizmo.text = get_plugin_name()
	add_control_to_container(CONTAINER_TOOLBAR, gizmo)

func make_visible(visible):
	if visible:
		rpgPlugin.show()
	else:
		rpgPlugin.hide()

func has_main_screen():
	return true
	
func get_plugin_name():
	return "RPG"

