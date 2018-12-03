extends Node2D
class_name ArmorSet

func defense(dmg_types : Array) -> float:
	var def := 0.0
	for child in get_children():
		if child is Armor:
			def += child.defense(dmg_types)
	return def
