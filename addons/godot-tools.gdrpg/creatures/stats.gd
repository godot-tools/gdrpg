extends Resource

export(Resource) var attributes
export var speed = 4.0
export var sprint_multi = 2.0
export var sprint_cost = 0.5
export var stamina_regen = 0.1

func tick():
	attributes.stam += stamina_regen
	
func save():
	return {
		"attributes": attributes.save(),
		"speed": speed,
		"sprint_multi": sprint_multi,
		"sprint_cost": sprint_cost,
		"stamina_regen": stamina_regen
	}
	
func restore(d):
	attributes.restore(d["attributes"])
	speed = d["speed"]
	sprint_multi = d["sprint_multi"]
	sprint_cost = d["sprint_cost"]
	stamina_regen = d["stamina_regen"]
