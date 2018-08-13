tool

extends Node

const SQLite = preload("res://addons/godot-tools.gdrpg/lib/gdsqlite.gdns")

export(String, FILE) var db_path = "res://addons/godot-tools.gdrpg/test.db"

var _db

func  _ready():
	_db = SQLite.new()
	
func open():
	return _db.open_db(db_path)
	
func close():
	return _db.close()

func query(q):
	return _db.query(q)

func fetch_array(q):
	return _db.fetch_array(q)

func last_insert_rowid():
	return _db.last_insert_rowid()

func loaded():
	return _db.loaded()
	