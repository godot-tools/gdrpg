tool

const OP_EQ = "=="
const OP_NE = "!="
const OP_LT = "<"
const OP_GT = ">"
const OP_GTE = ">="
const OP_LTE = "<="

var left_var = ""
var right_var = ""
var op = OP_EQ

func _init(left_var, op, right_var):
	self.left_var = left_var
	self.op = op
	self.right_var = right_var

func resolve(actor, db):
	var v1 = db.get_var(left_var)
	var v2 = db.get_var(right_var)
	
	if not v1 or not v2:
		return false

	match op:
		OP_EQ:
			return v1 == v2
		OP_NE:
			return v1 != v2
		OP_LT:
			return v1 < v2
		OP_GT:
			return v1 > v2
		OP_GTE:
			return v1 >= v2
		OP_LTE:
			return v1 <= v2
	return false

func to_string():
	return left_var + " " + str(op) + " " + right_var