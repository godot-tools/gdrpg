tool

extends PanelContainer

onready var editor = get_node("VBoxContainer/DialogEditor")
onready var _no_tree = get_node("VBoxContainer/NoTreeSelected")
onready var _new_btn = get_node("VBoxContainer/HBoxContainer/NewDTButton")
onready var _fd = get_node("FileDialog")

func _ready():
	_new_btn.connect("pressed", self, "_new_btn_pressed")
	_fd.connect("file_selected", self, "_file_selected")

func _new_btn_pressed():
	_fd.popup_centered()

func _file_selected(path):
	_no_tree.hide()
	editor.show()
	editor.tree_path = path