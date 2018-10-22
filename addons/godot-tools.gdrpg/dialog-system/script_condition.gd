extends Resource

export(Script) var script = "" setget _set_script

var _script

func resolve(actor, db):
	_script.resolve(actor, db)
	
func _set_script(val):
	_script = script.new()