extends Panel

onready var _dialog_tree = get_node("DialogTree")
onready var _responses = get_node("HBoxContainer/ResponseGroup")
onready var _dialog = get_node("HBoxContainer/Text")

func _ready():
	set_dnode()

func set_dnode(dnode=null):
	var node = dnode if dnode else _dialog_tree.get_root()
	_dialog.text = node.text
	_clear_responses()
	var responses = _dialog_tree.get_responses(node)
	if responses.empty():
		_responses.hide()
	else:
		_responses.show()
	for resp in responses:
		_add_response(node, resp)

func _clear_responses():
	for child in _responses.get_children():
		_responses.remove_child(child)
		child.queue_free()

func _add_response(node, resp):
	var b = Button.new()
	b.text = resp.text
	b.size_flags_horizontal = SIZE_EXPAND_FILL
	b.connect("pressed", self, "_on_press", [node, resp])
	_responses.add_child(b)

func _on_press(node, resp):
	var child = _dialog_tree.get_child(node, resp)
	set_dnode(child)
