const SQLite = preload("res://addons/godot-tools.gdrpg/lib/gdsqlite.gdns")

const _db_path = "res://addons/godot-tools.gdrpg/test.db"

enum COND_TYPE {
	VAR,
	SCRIPT
}
	
func _ensure_tables(db):
	var res = _query(db, """CREATE TABLE IF NOT EXISTS DialogNode(
		id TEXT PRIMARY KEY,
		name TEXT NOT NULL,
		text TEXT NOT NULL,
		posx INT DEFAULT 0,
		posy INT DEFAULT 0
	);""")
	if res != OK:
		return res
	res = _query(db, """CREATE TABLE IF NOT EXISTS DialogResponse(
		id TEXT PRIMARY KEY,
		text TEXT NOT NULL,
		nodeid TEXT NOT NULL,
		FOREIGN KEY(nodeid) REFERENCES DialogNode(id)
	);""")
	if res != OK:
		return res
	res = _query(db, """CREATE TABLE IF NOT EXISTS DialogConnection(
		idx INT NOT NULL,
		nodeid TEXT NOT NULL,
		respid TEXT NOT NULL,
		PRIMARY KEY (nodeid, respid),
		FOREIGN KEY(nodeid) REFERENCES DialogNode(id),
		FOREIGN KEY(respid) REFERENCES DialogResponse(id)
	);""")
	if res != OK:
		return res
	res = _query(db, """CREATE TABLE IF NOT EXISTS DialogCondition(
		left TEXT NOT NULL,
		right TEXT,
		type INT NOT NULL,
		op VARCHAR(2),
		cond_op VARCHAR(3) NOT NULL,
		respid INT NOT NULL,
		PRIMARY KEY (left, right, type, op, cond_op, respid)
		FOREIGN KEY(respid) REFERENCES DialogResponse(id)
	);""")
	return res

func _query(db, q):
	if not db.query(q):
		return ERR_QUERY_FAILED
	return OK