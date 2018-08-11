tool

const Condition = preload("res://addons/godot-tools.gdrpg/dialog-system/condition.gd")

var id = ""
var text = ""
var cond_ops = []
var child_idx = -1

func _init(id, text):
	self.id = id
	self.text = text
	
func add_condition(cond, op):
	var cond_op = ConditionOp.new(cond, op)
	cond_ops.push_back(cond_op)
	
func resolve_conditions():
	var last_op
	var last_result = true
	for cond_op in cond_ops:
		var result = cond_op.cond.resolve()
		if last_op and last_result:
			match last_op:
				"AND":
					result = last_result and result
				"OR":
					result = last_result or result
		last_result = result
		last_op = cond_op.op
	return last_result

func condition_string():
	if cond_ops.empty():
		return "No conditions specified."
		
	var s = ""
	for cond_op in cond_ops:
		var cond = cond_op.cond
		print(cond)
		if typeof(cond) == TYPE_OBJECT and cond is Condition:
			s += " " + cond.to_string()
		elif typeof(cond) == TYPE_STRING:
			s += " " + cond
		if cond_ops[-1] != cond_op:
			s += " " + cond_op.op
	return s.strip_edges()

class ConditionOp:
	var cond
	var op
	
	func _init(cond, op):
		self.cond = cond
		self.op = op


