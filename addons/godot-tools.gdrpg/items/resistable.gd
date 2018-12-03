extends Node2D
class_name Resistable

export var acid_resist := 0.0
export var cold_resist := 0.0
export var fire_resist := 0.00
export var force_resist := 0.0
export var lightning_resist := 0.0
export var necrotic_resist := 0.0
export var poison_resist := 0.0
export var psychic_resist := 0.0
export var radiant_resist := 0.0
export var bludgeoning_resist := 0.0
export var slashing_resist := 0.0
export var piercing_resist := 0.0

func resist(type : String) -> float:
	return get(type)

func resist_all(types : Array) -> float:
	var total := 0.0
	for type in types:
		if type is String:
			total += resist(type)
	return total
