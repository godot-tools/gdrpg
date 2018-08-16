extends Node

const Response = preload("res://addons/godot-tools.gdrpg/dialog-system/response.gd")
const Condition = preload("res://addons/godot-tools.gdrpg/dialog-system/condition.gd")
const DNode = preload("res://addons/godot-tools.gdrpg/dialog-system/dnode.gd")

enum COND_TYPE {
	VAR,
	SCRIPT
}

export(NodePath) var sqlite_node = "/root/SQLite"
export(String) var root_id = ""

onready var _sqlite = get_node(sqlite_node)

func get_root():
	var ret
	var q = """
	SELECT *
	FROM DialogNode
	WHERE id = '%s';
	""" % root_id
	_sqlite.open()
	var res = _sqlite.fetch_array(q)
	_sqlite.close()
	if not res:
		return ERR_DOES_NOT_EXIST
	return _new_dnode(res[0])

func get_responses(root=null):
	var rid = root.id if root else root_id
	var q = """
	SELECT *
	FROM DialogResponse
	WHERE nodeid = '%s';
	""" % rid
	var responses = []
	for row in res:
		var resp = Response.new(row["id"], row["text"])
		resp.cond_opts = _get_conditions(resp)
		if resp.resolve_conditions():
			responses.push_back(resp)
	return responses

func get_children(root):
	var children = []
	var q = """
	SELECT *
	FROM DialogNode
	WHERE parentid = '%s';
	""" % root.id
	_sqlite.open()
	var res = _sqlite.fetch_array(q)
	_sqlite.close()
	if not res:
		return children
	for row in res:
		var child = _new_dnode(row)
		children.push_back(child)
	return children

func get_child(root, resp):
	var responses = get_responses(root)
	var idx
	for i in range(responses.length()):
		if responses[i].id == resp.id:
			idx = i
	if not idx:
		return null
	var children = get_children(root)
	for child in children:
		for r in child.resp_indicies:
			if r == idx:
				return child
	return null

func _new_dnode(res):
	var pos = Vector2(float(res["posx"]), float(res["posy"]))
	var dnode = DNode.new(res["id"], res["name"], pos, res["text"])
	_parse_resp_idxs(res["respidxs"], dnode.resp_indicies)
	return dnode

func _get_conditions(resp):
	var cond_ops = []
	var q = """
	SELECT *
	FROM DialogCondition
	WHERE respid = '%';
	""" % resp.id
	var res = _sqlite.fetch_array(q)
	if not res:
		return cond_ops
	for row in res:
		var cond
		match row["type"]:
			VAR:
				cond = Condition.new(row["left"], row["op"], row["right"])
			SCRIPT:
				cond = row["left"]
		if cond:
			var cond_op = Response.ConditionOp.new(cond, row["cond_op"])
			cond_ops.push_back(cond_op)
	return cond_ops

func _parse_resp_idxs(resp_idxs, out):
	var parts = resp_idxs.split(",")
	for part in parts:
		out.push_back(int(part))
	