tool 

extends GraphEdit

const DNode = preload("res://addons/godot-tools.gdrpg/dialog-system/dnode.gd")
const SpeechNode = preload("res://addons/godot-tools.gdrpg/dialog-system/UI/SpeechNode.tscn")
const Exporter = preload("res://addons/godot-tools.gdrpg/dialog-system/dialog_node_json_exporter.gd")
const Importer = preload("res://addons/godot-tools.gdrpg/dialog-system/dialog_node_json_importer.gd")


onready var _root = get_node("DialogRoot")
onready var _context_menu = get_node("NewNodePopup")

var tree_path setget _set_tree_path

func _ready():
	_context_menu.connect("id_pressed", self, "_on_new_node")
	connect("connection_request", self, "_connection_request")
	connect("disconnection_request", self, "_disconnect_request")
	set_dnode(DNode.new(_root.title, _root.name, Vector2(100, 80)))
	

func set_dnode(dnode):
	_clear()
	# Ensure that we have the correct name. This should already be case
	# but can never be too sure with user provided data ¯\_(ツ)_/¯
	dnode.name = _root.name
	_root.dnode = dnode
	_init_dnodes(_root)

func save():
	var exporter = Exporter.new(_root.dnode)
	exporter.export_node(tree_path)

func is_root(node):
	return node == _root

func sweep():
	var used = {}
	var conns = get_connection_list()
	for conn in conns:
		used[conn["to"]] = true
	for child in get_children():
		if child != _root and not used[child.name]:
			remove_child(child)
			child.queue_free()

func _init_dnodes(root_node):
	var root = root_node.dnode
	for child in root.children:
		if not child.resp_indicies.empty():
			for resp_idx in child.resp_indicies:
				connect_node(root.name, resp_idx, child.name, 0)
				root_node.set_slot(resp_idx+2, false, 0, ColorN("white"), true, 1, ColorN("blue"))
			var child_node = get_speech_node(child.name)
			if not child_node:
				child_node = _new_speech_node(child)
			_init_dnodes(child_node)

func _on_new_node(id):
	match id:
		0:
			_new_speech_node()

func _new_speech_node(dnode=null):
	var node = SpeechNode.instance()
	add_child(node)
	if not dnode:
		dnode = DNode.new("", node.name, Vector2(400, 100))
	node.dnode = dnode
	return node

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		_context_menu.popup(Rect2(event.global_position, Vector2(138.0, 26.0)))
		accept_event()
	
		
func _connection_request(from, from_slot, to, to_slot):
	var from_node = get_speech_node(from)
	var to_node = get_speech_node(to)
	var has_connection = from_node.dnode.has_connection(from_slot)
	var is_connected = is_node_connected(from, from_slot, to, to_slot)
	if not has_connection:
		if not from_node.dnode.children.has(to_node.dnode):
			from_node.dnode.children.push_back(to_node.dnode)
		to_node.dnode.resp_indicies.push_back(from_slot)
		from_node.set_slot(from_slot+2, false, 0, ColorN("white"), true, 1, ColorN("blue"))
		connect_node(from, from_slot, to, to_slot)

func _disconnect_request(from, from_slot, to, to_slot):
	var from_node = get_speech_node(from)
	var to_node = get_speech_node(to)
	from_node.dnode.remove_child(to_node.dnode)
	from_node.set_slot(from_slot+2, false, 0, ColorN("white"), true, 0, ColorN("white"))
	disconnect_node(from, from_slot, to, to_slot)

func _close_request(node):
	_disconnect_node(node)
	remove_child(node)
	node.queue_free()

func _disconnect_node(node):
	var conn_list = get_connection_list()
	for conn in conn_list:
		if conn["from"] == node.name:
			node.set_slot(conn["from_slot"]+2, false, 0, ColorN("white"), true, 0, ColorN("white"))
		elif conn["to"] == node.name:
			node.set_slot(conn["to_slot"], true, 0, ColorN("white"), false, 0, ColorN("white"))
		disconnect_node(conn["from"], conn["from_port"], conn["to"], conn["to_port"])

func _is_node_connected(node):
	var conns = get_connection_list()
	for conn in conns:
		if conn["from"] == node.name:
			return true
	return false

func _clear():
	_root.clear_responses()
	clear_connections()
	for child in get_children():
		if child != _root and  child is GraphNode:
			remove_child(child)
			child.queue_free()
	_root.dnode = null

func get_speech_node(name):
	for child in get_children():
		if child.name == name:
			return child
	return null

func _set_tree_path(val):
	if tree_path:
		save()
	tree_path = val
	var f = File.new()
	if f.file_exists(val):
		_load(val)
	else:
		set_dnode(DNode.new("", _root.name, Vector2(100, 80)))
	f.close()

func _load(path):
	var importer = Importer.new()
	var dnode = importer.import_node(path)
	set_dnode(dnode)
