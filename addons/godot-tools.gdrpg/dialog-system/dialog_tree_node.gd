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
	INNER JOIN DialogCondition
	ON DialogCondition.respid = DialogResponse.id
	WHERE nodeid = '%s';
	""" % rid
	var responses = {}
	_sqlite.open()
	var res = _sqlite.fetch_array(q)
	_sqlite.close()
	for row in res:
		var resp
		if responses.has(row["id"]):
			resp = responses[row["id"]]
		else:
			resp = Response.new(row["id"], row["text"])
			responses[resp.id] = resp
		var cond_op = _new_condition_op(row)
		if cond_op:
			resp.cond_ops.push_back(cond_op)
	return responses.values()

func get_children(root=null):
	var rid = root.id if root else root_id
	var children = []
	var q = """
	SELECT *
	FROM DialogNode
	WHERE id = (
		SELECT nodeid
		FROM DialogConnection
		WHERE respid = (
			SELECT id
			FROM DialogResponse
			WHERE nodeid = '%s'
		)
		ORDER BY idx ASC
	);
	""" % rid
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
	var q = """
	SELECT *
	FROM DialogNode
	WHERE id = (
		SELECT nodeid
		FROM DialogConnection
		WHERE respid = '%s'
	);
	""" % resp.id
	_sqlite.open()
	var res = _sqlite.fetch_array(q)
	_sqlite.close()
	if not res:
		return null
	return _new_dnode(res[0])

func _new_dnode(res):
	var pos = Vector2(float(res["posx"]), float(res["posy"]))
	var dnode = DNode.new(res["id"], res["name"], pos, res["text"])
	return dnode

func _new_condition_op(row):
	var cond
	match row["type"]:
		VAR:
			cond = Condition.new(row["left"], row["op"], row["right"])
		SCRIPT:
			cond = row["left"]
	return Response.ConditionOp.new(cond, row["cond_op"]) if cond else null