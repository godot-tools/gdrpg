tool

extends "res://addons/godot-tools.gdrpg/dialog-system/base_sqlite_serde.gd"

const Condition = preload("res://addons/godot-tools.gdrpg/dialog-system/condition.gd")
const Response = preload("res://addons/godot-tools.gdrpg/dialog-system/response.gd")
const DNode = preload("res://addons/godot-tools.gdrpg/dialog-system/dnode.gd")

func import_node(id):
	var node
	var db = SQLite.new()
	db.open_db(_db_path)
	var res = _ensure_tables(db)
	if res == OK:
		node = _build_node(db, id)
	db.close()
	return node

func _build_node(db, id):
	var q = """
	SELECT name, text, respidxs, posx, posy
	FROM DialogNode 
	WHERE id = '%s';
	""" % id
	var res = db.fetch_array(q)
	if not res or res.empty():
		return null
	var d = res[0]
	var pos = Vector2(float(d["posx"]), float(d["posy"]))
	var node = DNode.new(id, d["name"], pos, d["text"])
	_parse_resp_idxs(d["respidxs"], node.resp_indicies)
	_build_responses(db, id, node.responses)
	var children = _get_children(db, id)
	for child_id in children:
		var child = _build_node(db, child_id)
		if not child:
			return null
		node.children.push_back(child)
	return node

func _build_responses(db, id, out):
	var q = """
	SELECT id, text
	FROM DialogResponse
	WHERE nodeid = '%s';
	""" % id
	var res = db.fetch_array(q)
	if not res:
		return
	for entry in res:
		var resp = Response.new(entry["id"], entry["text"])
		_build_cond_ops(db, entry["id"], resp.cond_ops)
		out.push_back(resp)

func _build_cond_ops(db, id, out):
	var q = """
	SELECT type, left, right, op, cond_op
	FROM DialogCondition
	WHERE respid = '%s';
	""" % id
	var res = db.fetch_array(q)
	if not res:
		return
	for entry in res:
		var cond_op
		match entry["type"]:
			VAR:
				var cond = Condition.new(entry["left"], entry["op"], entry["right"])
				cond_op = Response.ConditionOp.new(cond, entry["cond_op"])
			SCRIPT:
				cond_op = Response.ConditionOp.new(entry["left"], entry["cond_op"])
		
		if cond_op:
			out.push_back(cond_op)

func _parse_resp_idxs(resp_idxs, out):
	var parts = resp_idxs.split(",")
	for part in parts:
		out.push_back(int(part))

func _get_children(db, id):
	var out = []
	var q = """
	SELECT id
	FROM DialogNode
	WHERE parentid = '%s';
	""" % id
	var res = db.fetch_array(q)
	if not res:
		return out
	for entry in res:
		out.push_back(entry["id"])
	return out