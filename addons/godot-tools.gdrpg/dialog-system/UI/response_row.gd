tool

extends HBoxContainer

const NewResponseDialog = preload("res://addons/godot-tools.gdrpg/dialog-system/UI/NewResponseDialog.tscn")

var parent_dialog
var response setget _set_resp

onready var _id = get_node("ID")
onready var _conditions = get_node("Conditions")
onready var _remove_btn = get_node("Remove")

signal removed

func _ready():
	_remove_btn.connect("pressed", self, "_remove_pressed")
	_id.connect("gui_input", self, "_gui_input")

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and event.doubleclick:
		var dialog = NewResponseDialog.instance()
		dialog.connect("new_response", self, "_edit_response")
		parent_dialog.add_child(dialog)
		dialog.popup_centered(Vector2(0, 0))
		dialog.set_response_row(self)

func _set_resp(val):
	response = val
	_id.text = val.trid
	_conditions.text = val.condition_string()

func _edit_response(resp):
	_set_resp(resp)

func _remove_pressed():
	emit_signal("removed", self)

