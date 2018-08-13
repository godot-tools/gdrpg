tool

extends WindowDialog

onready var _sqlite = get_node("../SQLite")
onready var _item_list = get_node("ScrollContainer/ItemList")
onready var _okay = get_node("HBoxContainer/Okay")
onready var _cancel = get_node("HBoxContainer/Cancel")

signal item_selected

func _ready():
	connect("about_to_show", self, "_about_to_show")
	_item_list.connect("nothing_selected", self, "_on_nothing_selected")
	_item_list.connect("item_selected", self, "_on_item_selected")	
	_okay.connect("pressed", self, "_on_okay")
	_cancel.connect("pressed", self, "_on_cancel")

func _about_to_show():
	_item_list.clear()
	_populate_items()

func _on_nothing_selected():
	_okay.disabled = true

func _on_item_selected(item):
	_okay.disabled = false

func _on_okay():
	var selections = _item_list.get_selected_items()
	var id = _item_list.get_item_text(selections[0])
	emit_signal("item_selected", id)
	hide()

func _on_cancel():
	hide()
	
func _populate_items():
	_sqlite.open()
	print("loaded populat? ", _sqlite.loaded())
	var res = _sqlite.fetch_array("SELECT id FROM DialogNode;")
	if res:
		for entry in res:
			_item_list.add_item(entry["id"])

	_sqlite.close()
	
