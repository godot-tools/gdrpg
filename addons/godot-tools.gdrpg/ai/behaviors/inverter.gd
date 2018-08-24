"""
Inverter is a Decorator node that returns the netgation of its child's result.
"""

extends "res://addons/godot-tools.gdrpg/ai/behaviors/btnode.gd"

const Error = preload("res://addons/godot-tools.gdrpg/ai/behaviors/error.gd")

func tick(ctx):
	if get_child_count() != 1:
		return Error.new(self, str("[ERR]: Inverter must have exactly one child. ", name, " has ", get_child_count(), "."))

	var result = get_child(0)._execute(ctx)
	
	if (typeof(result) == TYPE_OBJECT and result is Error) or result == ERR_BUSY:
		return result
	
	if result == OK:
		return FAILED
	
	if result == FAILED:
		return OK
		
	return Error.new(self, str("Invalid state: ", result))
