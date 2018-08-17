		extends "res://addons/godot-tools.gdrpg/dialog-system/base_sqlite_serde.gd"

const Condition = preload("res://addons/godot-tools.gdrpg/dialog-system/condition.gd")
	
func export_node(node):
	var db = SQLite.new()
	db.open_db(_db_path)
	var res = _ensure_tables(db)
	if res == OK:
		res = _write_to_db(db, node)
	db.close()
	return res

func _write_to_db(db, root):
	var res = _write_node_to_db(db, root)
	if res != OK:
		return res
	for child in root.children:
		res = _write_to_db(db, child)
		if res != OK:
			return res
		res = _write_connections(db, child, root)
		if res != OK:
			return res
	return OK
func _write_node_to_db(db, node):
	var q = """
	INSERT OR REPLACE INTO 
	DialogNode (id, name, text, posx, posy) 
	VALUES ('%s', '%s', '%s', %d, %d);
	""" % [node.id, node.name, node.text, node.pos.x, node.pos.y]
	var res = _query(db, q)
	if res != OK:
		return res
	for i in range(node.responses.size()):
		var resp = node.responses[i]
		res = _write_response(db, resp, node.id)
		if res != OK:
			return res
	return OK

func _write_connections(db, node, parent):
	for resp_idx in node.resp_indicies:
		var resp = parent.responses[resp_idx]
		if not resp:
			print("No resp!")
			continue
		print(resp_idx, " ", resp.id)
		var q = """
		INSERT OR REPLACE INTO
		DialogConnection (idx, nodeid, respid)
		VALUES (%d, '%s', '%s');
		""" % [resp_idx, node.id, resp.id]
		var res = _query(db, q)
		if res != OK:
			return res
	return OK

func _write_response(db, resp, node_id):
	var q = """INSERT OR REPLACE INTO 
	DialogResponse (id, text, nodeid) 
	VALUES('%s', '%s', '%s');""" % [resp.id, resp.text, node_id]
	var res = _query(db, q)
	if res != OK:
		return res
	for cond_op in resp.cond_ops:
		res = _write_cond(db, cond_op, resp.id)
		if res != OK:
			return res
	return OK
#
func _write_cond(db, cond_op, resp_id):
	var cond = cond_op.cond
	var q = ""
	if typeof(cond) == TYPE_OBJECT and cond is Condition:
		q = """
		INSERT INTO 
		DialogCondition (type, left, right, op, cond_op, respid) 
		VALUES (%d, '%s', '%s', '%s', '%s', '%s');
		""" % [VAR, cond.left_var, cond.right_var, cond.op, cond_op.op, resp_id]
	elif typeof(cond) == TYPE_STRING:
		q = """INSERT INTO 
		DialogCondition (type, left, cond_op, resp_id) 
		VALUES (%d, '%s', '%s', '%s');
		""" % [SCRIPT, cond, cond_op, resp_id]
	return _query(db, q)

func _new_cond_id(db):
	var q = """
	SELECT COUNT(*) AS count
	FROM DialogCondition
	"""
	var res = db.fetch_array(q)
	if not res:
		return 0
	return res[0]["count"] + 1
