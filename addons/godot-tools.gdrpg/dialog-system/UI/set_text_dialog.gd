tool

extends WindowDialog

const ResponseRow = preload("res://addons/godot-tools.gdrpg/dialog-system/UI/ResponseRow.tscn")
const NewResponseDialog = preload("res://addons/godot-tools.gdrpg/dialog-system/UI/NewResponseDialog.tscn")

var node setget _set_node

onready var _say = get_node("VBoxContainer/Say/LineEdit")
onready var _id = get_node("VBoxContainer/ID/LineEdit")
onready var _responses = get_node("VBoxContainer/Responses/ScrollContainer/VBoxContainer")
onready var _no_responses = get_node("VBoxContainer/Responses/NoResponses")
onready var _new_response = get_node("VBoxContainer/Responses/ResponseHeader/NewResponse")
onready var _okay = get_node("ButtonBar/Okay")

func _ready():
	_okay.connect("pressed", self, "_okay")
	_id.connect("text_changed", self, "_text_changed")
	_say.connect("text_changed", self, "_text_changed")
	_new_response.connect("pressed", self, "_new_response")
	get_node("ButtonBar/Cancel").connect("pressed", self, "_cancel")

func add_response_row(row):
	if _no_responses:
		_no_responses.get_parent().remove_child(_no_responses)
		_no_responses.queue_free()
		_no_responses = null
	_responses.add_child(row)

func _text_changed(new_text):
	_okay.disabled = _say.text.empty() or _id.text.empty()

func _set_node(val):
	node = val
	_id.text = node.id
	_say.text = node.text
	_populate_responses(node.get_responses())

func _new_response():
	var resp_row = _new_response_row()
	var dialog = NewResponseDialog.instance()
	add_child(dialog)
	dialog.set_response_row(resp_row)
	dialog.popup_centered(Vector2(273, 234))

func _response_row_removed(row):
	_responses.remove_child(row)
	row.queue_free()

func _okay():
	hide()
	get_parent().remove_child(self)
	if node:
		node.id = _id.text
		node.text = _say.text
		_add_responses_to_node()
	queue_free()

func _cancel():
	hide()
	get_parent().remove_child(self)
	queue_free()

func _add_responses_to_node():
	node.clear_responses()
	for child in _responses.get_children():
		node.add_response(child.response)
	node.reconnect_slots()
		
func _populate_responses(responses):
	for resp in responses:
		var row = _new_response_row()
		add_response_row(row)
		row.response = resp

func _new_response_row():
	var row = ResponseRow.instance()
	row.connect("removed", self, "_response_row_removed")
	row.parent_dialog = self
	return row
