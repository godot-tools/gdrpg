tool

extends Node

const _VARS = "__vars__"

var _mem = {
	_VARS: {},
}
	
func set_var(key, val):
	_mem[_VARS][key] = val

func get_var(key):
	return _mem[_VARS][key]
