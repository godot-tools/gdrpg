tool

extends HBoxContainer

var response setget _set_resp

signal deleted

onready var _text = get_node("Text")
onready var _delete = get_node("Delete")

func _ready():
	_delete.connect("pressed", self, "_delete_pressed")
	
func _delete_pressed():
	emit_signal("deleted", self)

func _set_resp(val):
	response = val
	_text.text = response.trid
	