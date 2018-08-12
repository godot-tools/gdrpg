extends Node

const SQLite = preload("res://addons/godot-tools.gdrpg/sqlite/lib/gdsqlite.gdns")

export(String, FILE) var db_file = ""

var _db

func _ready():
	_db = SQLite.new()
	_db.open_db(db_file)

func _exit_tree():
	if _db and _db.loaded():
		_db.close()
		
func query(q):
	return _db.query(q)

func fetch_array(q):
	return _db.fetch_array(q)
	
func last_insert_rowid():
	return _db.last_insert_rowid()
