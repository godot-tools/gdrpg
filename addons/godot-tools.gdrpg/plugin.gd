tool

extends EditorPlugin

func _enter_tree():
	# Resources
	
	# Custom types
	add_custom_type("Blackboard", "Node2D", preload("res://addons/godot-tools.gdrpg/blackboard.gd"), preload("res://addons/godot-tools.gdrpg/blackboard.png"))
	
	# Dialog
	add_custom_type("DialogNode", "Node", preload("res://addons/godot-tools.gdrpg/dialog-system/dnode.gd"), null)
	add_custom_type("DialogScriptCondition", "Resource", preload("res://addons/godot-tools.gdrpg/dialog-system/script_condition.gd"), null)
	add_custom_type("DialogVarCondition", "Resource", preload("res://addons/godot-tools.gdrpg/dialog-system/var_condition.gd"), null)
	
	# Quests
	add_custom_type("Quest", "Node", preload("res://addons/godot-tools.gdrpg/quests/quest.gd"), null)
	add_custom_type("Task", "Node", preload("res://addons/godot-tools.gdrpg/quests/task.gd"), null)
	
	# AI
	add_custom_type("BehaviorTree", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/behavior_tree.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/tree.png"))
	add_custom_type("Selector", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/selector.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/selector.png"))
	add_custom_type("Sequence", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/sequence.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/sequence.png"))
	add_custom_type("Inverter", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/inverter.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/inverter.png"))
	add_custom_type("Repeater", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/repeater.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/repeater.png"))
	add_custom_type("Succeeder", "Node2D", preload("res://addons/godot-tools.gdrpg/ai/behaviors/succeeder.gd"), preload("res://addons/godot-tools.gdrpg/ai/icons/succeeder.png"))
	
	# Creatures
	add_custom_type("Creature", "KinematicBody2D", preload("res://addons/godot-tools.gdrpg/creatures/creature.gd"), null)
	
	# Items
	add_custom_type("Weapon", "Node2D", preload("res://addons/godot-tools.gdrpg/items/weapon.gd"), null)
	add_custom_type("Resistable", "Node2D", preload("res://addons/godot-tools.gdrpg/items/resistable.gd"), null)
	add_custom_type("Armor", "Resistable", preload("res://addons/godot-tools.gdrpg/items/armor.gd"), null)
	add_custom_type("ArmorSet", "Node2D", preload("res://addons/godot-tools.gdrpg/items/armor_set.gd"), null)
	
	# Utility
	add_custom_type("AnimatedSpriteSheet", "Sprite", preload("res://addons/godot-tools.gdrpg/util/animated_sprite.gd"), null)
	
func _exit_tree():
	# Custom Types
	
	# Utility
	remove_custom_type("AnimatedSpriteSheet")
	
	# Items
	remove_custom_type("ArmorSet")
	remove_custom_type("Armor")
	remove_custom_type("Resistable")
	remove_custom_type("Weapon")
	
	# Creatures
	remove_custom_type("Creature")
	
	# AI
	remove_custom_type("BehaviorTree")
	remove_custom_type("Selector")
	remove_custom_type("Sequence")
	remove_custom_type("Inverter")
	remove_custom_type("Repeater")
	remove_custom_type("Succeeder")
	
	# Quests
	remove_custom_type("Task")
	remove_custom_type("Quest")
	
	# Dialog
	remove_custom_type("DialogNode")
	remove_custom_type("DialogScriptCondition")
	remove_custom_type("DialogVarCondition")
	
	remove_custom_type("Blackboard")
	
	# Resources
	
func get_plugin_name():
	return "GRPG"

