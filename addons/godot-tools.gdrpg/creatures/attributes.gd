extends Resource

export var hp = 100.0 setget _set_hp
export var max_hp = 100.0 setget _set_max_hp
export var mp = 100.0 setget _set_mp
export var max_mp = 100.0 setget _set_max_mp
export var stam = 100.0 setget _set_stam
export var max_stam = 100.0 setget _set_max_stam

func save():
	return {
		"hp": hp,
		"max_hp": max_hp,
		"mp": mp,
		"max_mp": max_mp,
		"stam": stam,
		"max_stam": max_stam,
	}

func restore(d):
	_set_max_hp(d["max_hp"])
	_set_max_mp(d["max_mp"])
	_set_max_stam(d["max_stam"])
	_set_hp(d["hp"])
	_set_mp(d["mp"])
	_set_stam(d["stam"])
	

func _set_hp(val):
	if val < 0:
		val = 0
	hp = min(val, max_hp)

func _set_max_hp(val):
	max_hp = val
	_set_hp(hp)

func _set_mp(val):
	if val < 0:
		val = 0
	mp = min(val, max_mp)

func _set_max_mp(val):
	if val < 0:
		val = 0
	max_mp = val
	_set_mp(mp)

func _set_stam(val):
	if val < 0:
		val = 0
	stam = min(val, max_stam)

func _set_max_stam(val):
	if val < 0:
		val = 0
	max_stam = val
	_set_stam(stam)
