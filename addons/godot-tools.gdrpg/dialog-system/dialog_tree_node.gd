extends Node

const Importer = preload("res://addons/godot-tools.gdrpg/dialog-system/dialog_node_json_importer.gd")

export(String, FILE, "*.dt ; DialogTree files") var tree_path

var _tree

func _ready():
	if tree_path:
		var importer = Importer.new()
		_tree = importer.import_node(tree_path)
		if typeof(_tree) == TYPE_INT:
			print("error importing file! ", _tree)

func get_root():
	return _tree

func get_responses(root=null):
	if not root:
		root = _tree
	var responses = []
	for resp in root.responses:
		if resp.resolve_conditions():
			responses.push_back(resp)
	return responses

func get_child(resp):
	return _get_child(_tree, resp)

func _get_child(root, resp):
	var child = root.get_child_for_resp(resp)
	if child:
		return child
	for c in root.children:
		child = _get_child(c, resp)
		if child:
			return child
	return null
