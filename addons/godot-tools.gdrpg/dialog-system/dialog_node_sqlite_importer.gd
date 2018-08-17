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
	var node = _get_node(db, id)
	_build_responses(db, id, node.responses)
	_build_connections(db, node)
	print("children: ", node.children.size())
	return node

func _build_connections(db, node):
	print("building connections for node: ", node.id)
	for resp in node.responses:
		print("building connection for resp ", resp.id)
		var q = """
		SELECT *
		FROM DialogConnection
		WHERE respid = '%s';
		""" % [resp.id]
		print(q)
		var res = db.fetch_array(q)
		if not res:
			print("no res!")
			continue
		for row in res:
			var child = _get_node(db, row["nodeid"])
			child.resp_indicies.push_back(row["idx"])
			node.children.push_back(child)
			_build_responses(db, child.id, child.responses)
			_build_connections(db, child)

func _get_node(db, id):
	var q = """
	SELECT name, text, posx, posy
	FROM DialogNode 
	WHERE id = '%s';
	""" % id
	var res = db.fetch_array(q)
	if not res or res.empty():
		return null
	var d = res[0]
	var pos = Vector2(float(d["posx"]), float(d["posy"]))
	var node = DNode.new(id, d["name"], pos, d["text"])
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
