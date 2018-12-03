extends "res://addons/godot-tools.gdrpg/items/resistable.gd"
class_name Armor

export var physical_defense := 0.0

func defense(dmg_types : Array) -> float:
	var resist := resist_all(dmg_types)
	return physical_defense + resist

