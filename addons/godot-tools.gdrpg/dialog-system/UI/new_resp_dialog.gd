tool

extends WindowDialog

const NewConditionDialog = preload("res://addons/godot-tools.gdrpg/dialog-system/UI/NewConditionDialog.tscn")
const ConditionRow = preload("res://addons/godot-tools.gdrpg/dialog-system/UI/ConditionRow.tscn")
const Response = preload("res://addons/godot-tools.gdrpg/dialog-system/response.gd")
const Condition = preload("res://addons/godot-tools.gdrpg/dialog-system/condition.gd")

onready var _ok = get_node("ButtonBar/Okay")
onready var _id = get_node("VBoxContainer/ID/LineEdit")
onready var _text = get_node("VBoxContainer/Text/LineEdit")
onready var _conditions = get_node("VBoxContainer/Conditions/ScrollContainer/VBoxContainer")
onready var _new_condition = get_node("VBoxContainer/Conditions/ConditionsHeader/NewCondition")
onready var _no_conditions = get_node("VBoxContainer/Conditions/NoConditions")
onready var _file_dialog = get_node("FileDialog")

var _db
var _resp_row

signal new_response

func _ready():
	_ok.connect("pressed", self, "_okay")
	_id.connect("text_changed", self, "_text_changed")
	_text.connect("text_changed", self, "_text_changed")
	_new_condition.get_popup().connect("id_pressed", self, "_new_condition_pressed")
	_file_dialog.connect("file_selected", self, "_file_selected")
	get_node("ButtonBar/Cancel").connect("pressed", self, "_cancel")

func _text_changed(new_text):
	_ok.disabled = _text.text.empty() or _id.text.empty()

func _new_condition_pressed(id):
	match id:
		0:
			_new_var_condition_dialog()
		1:
			_show_file_dialog()
	
func _new_var_condition_dialog():
	var dialog = NewConditionDialog.instance()
	dialog.connect("new_condition", self, "_on_new_condition")
	add_child(dialog)
	dialog.popup_centered()

func _show_file_dialog():
	_file_dialog.popup_centered()

func _file_selected(path):
	var res = load(path)
	if not res or not res is Script:
		return
	var script = res.new()
	if script.has_method("resolve"):
		_on_new_condition(path)

func _on_new_condition(cond):
	if _no_conditions.visible:
		_no_conditions.visible = false
	_new_condition_row(cond)

func _condition_removed(cond):
	_conditions.remove_child(cond)
	cond.queue_free()
	if _conditions.get_child_count() == 0:
		_no_conditions.visible = true

func _okay():
	var resp = _new_response()
	if not _resp_row.get_parent():
		get_parent().add_response_row(_resp_row)
	_resp_row.response = resp
	hide()
	get_parent().remove_child(self)
	queue_free()

func _cancel():
	hide()
	get_parent().remove_child(self)
	queue_free()
	
func set_response_row(resp_row):
	_resp_row = resp_row
	var resp = _resp_row.response
	if not resp:
		return
	_id.text = resp.id
	_text.text = resp.text
	if _no_conditions.visible and not resp.cond_ops.empty():
		_no_conditions.visible = false
	for cond_op in resp.cond_ops:
		_new_condition_row(cond_op.cond, cond_op.op)

func _new_condition_row(cond, op="AND"):
	var row = ConditionRow.instance()
	row.connect("condition_removed", self, "_condition_removed")
	_conditions.add_child(row)
	row.condition = cond
	row.op = op
	
func _new_response():
	var resp = Response.new(_id.text, _text.text)
	for child in _conditions.get_children():
		if child.is_in_group("ConditionRow"):
			resp.add_condition(child.condition, child.op)
	return resp