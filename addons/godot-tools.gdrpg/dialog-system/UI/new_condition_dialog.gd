tool

extends WindowDialog

const Condition = preload("res://addons/godot-tools.gdrpg/dialog-system/condition.gd")

onready var _left_var = get_node("VBoxContainer/LeftVar/LineEdit")
onready var _right_var = get_node("VBoxContainer/RightVar/LineEdit")
onready var _op = get_node("VBoxContainer/Operator/OptionButton")
onready var _ok_btn = get_node("VBoxContainer/ButtonBar/Okay")

signal new_condition

func _ready():
	_left_var.connect("text_changed", self, "_text_changed")
	_right_var.connect("text_changed", self, "_text_changed")
	_ok_btn.connect("pressed", self, "_okay")
	get_node("VBoxContainer/ButtonBar/Cancel").connect("pressed", self, "_cancel")

func set_condition(cond):
	_left_var.text = cond.left_var
	_right_var.text = cond.right_var
	for i in range(_op.get_item_count()):
		if _op.get_item_text(i) == cond.op:
			_op.select(i)

func _text_changed(new_text):
	_ok_btn.disabled = _left_var.text.empty() or _right_var.text.empty()
	
func _okay():
	var cond = Condition.new(_left_var.text, _op.get_item_text(_op.selected), _right_var.text)
	emit_signal("new_condition", cond)
	hide()
	get_parent().remove_child(self)
	queue_free()

func _cancel():
	hide()
	get_parent().remove_child(self)
	queue_free()

