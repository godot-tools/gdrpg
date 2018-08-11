tool

const Condition = preload("res://addons/godot-tools.gdrpg/dialog-system/condition.gd")

enum COND_TYPE {
	VAR,
	SCRIPT
}

var _node

func _init(node):
	_node = node

func export_node(path):
	var f = File.new()
	f.open(path, File.WRITE)
	export_to_file(f)
	f.close()
	return f.get_error()

func export_to_file(f):
	var d = _build_config(_node)
	f.store_string(to_json(d))
	
func _build_config(root):
	var serialized = _serialize_node(root)
	for child in root.children:
		serialized["children"].push_back(_build_config(child))
	return serialized

func _serialize_node(node):
	var d = {
		"id": node.id,
		"name": node.name,
		"text": node.text,
		"resp_indicies": node.resp_indicies,
		"pos": {
			"x": node.pos.x,
			"y": node.pos.y
		},
		"responses": [],
		"children": [],
	}
	for resp in node.responses:
		var resp_d = {
			"id": resp.id,
			"text": resp.text,
			"conditions": [],
		}
		for cond_op in resp.cond_ops:
			if typeof(cond_op.cond) == TYPE_OBJECT and cond_op.cond is Condition:
				resp_d["conditions"].push_back({
					"type": VAR,
					"left_var": cond_op.cond.left_var,
					"right_var": cond_op.cond.right_var,
					"op": cond_op.cond.op,
					"cond_op": cond_op.op,
				})
			elif typeof(cond_op.cond) == TYPE_STRING:
				resp_d["conditions"].push_back({
					"type": SCRIPT,
					"path": cond_op.cond,
					"cond_op": cond_op.op,
				})
		d["responses"].push_back(resp_d)
	return d