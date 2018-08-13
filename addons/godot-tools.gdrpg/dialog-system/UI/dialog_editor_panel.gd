tool

extends PanelContainer

onready var _sqlite = get_node("SQLite")
onready var editor = get_node("VBoxContainer/DialogEditor")
onready var _no_tree = get_node("VBoxContainer/NoTreeSelected")
onready var _new_btn = get_node("VBoxContainer/HBoxContainer/New")
onready var _open_btn = get_node("VBoxContainer/HBoxContainer/Open")
onready var _save_btn = get_node("VBoxContainer/HBoxContainer/Save")
onready var _node_list = get_node("DNodeList")

func _ready():
	print(name)
	_new_btn.connect("pressed", self, "_new_btn_pressed")
	_open_btn.connect("pressed", self, "_open_btn_pressed")
	_save_btn.connect("pressed", self, "_on_save")
	_node_list.connect("item_selected", self, "_on_item_selected")
	editor.connect("node_updated", self, "_on_node_updated")
	$ConfirmationDialog.connect("confirmed", self, "_on_confirm")

func _on_node_updated(node):
	_save_btn.disabled = node == editor.root and not node.id

func _on_confirm():
	editor.save()

func _new_btn_pressed():
	_no_tree.hide()
	editor.show()
	editor.reset()
	_save_btn.disabled = true

func _open_btn_pressed():
	_node_list.popup_centered()

func _on_item_selected(item):
	_no_tree.hide()
	editor.show()
	editor.node_id = item

func _on_save():
	var exists = _id_exists(editor.root.id)
	print(exists)
	if exists:
		$ConfirmationDialog.popup_centered()
		return
	editor.save()

func _id_exists(id):
	_sqlite.open()
	var q = """
	SELECT id
	FROM DialogNode
	WHERE id = '%s';
	""" % id
	var res = _sqlite.fetch_array(q)
	_sqlite.close()
	return res and not res.empty()