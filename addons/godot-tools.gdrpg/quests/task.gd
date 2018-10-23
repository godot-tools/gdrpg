extends Node

export var flag = ""

var complete = false

func is_complete(bb):
	var val = bb.get(flag)
	return val != null

