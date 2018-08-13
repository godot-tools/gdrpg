tool

extends GraphNode

const SetTextDialog = preload("res://addons/godot-tools.gdrpg/dialog-system/UI/SetTextDialog.tscn")
const Slot = preload("res://addons/godot-tools.gdrpg/dialog-system/UI/Slot.tscn")

onready var _say = get_node("Say")
onready var _sep = get_node("HSeparator") 
onready var id setget _set_id, _get_id
onready var text = _say.text setget _set_text

var dnode setget _set_dnode

signal node_updated

func _ready():
	connect("resize_request", self, "_resize_request")
	connect("close_request", self, "_close_request")
	connect("dragged", self, "_dragged")

func add_response(resp, add_response=true):
	var slot = _new_slot(resp)
	if add_response:
		dnode.responses.push_back(resp)
	_sep.visible = true

func remove_response(resp):
	for child in get_children():
		if child.is_in_group("Slot") and child.response == resp:
			_slot_delted(child)
			return

func clear_responses():
	for child in get_children():
		if child.is_in_group("Slot"):
			_slot_deleted(child, false)

func get_responses():
	return dnode.responses.duplicate()

func _new_slot(resp):
	var slot = Slot.instance()
	add_child(slot)
	slot.connect("deleted", self, "_slot_deleted")
	slot.response = resp
	var color = ColorN("white")
	var type = 0
	var child = dnode.get_child_for_resp(resp)
	if child:
		color = ColorN("blue")
		type = 1
	set_slot(slot.get_index(), false, 0, ColorN("white"), true, type, color)
	return slot

func _slot_deleted(slot, disconnect_slots=true):
	var resp = slot.response
	if disconnect_slots:
		_disconnect_slots()
	remove_child(slot)
	# We compare to 2 here instead of 0 because
	# we still have the label and HSeparator nodes
	if get_child_count() <= 2:
		_sep.visible = false
	slot.queue_free()
	dnode.remove_response(resp, disconnect_slots)
	if disconnect_slots:
		reconnect_slots()

func _disconnect_slots():
	var graph = get_parent()
	var conns = graph.get_connection_list()
	for conn in conns:
		if conn["from"] == name:
			set_slot(conn["from_port"]+2, false, 0, ColorN("white"), true, 0, ColorN("white"))
			graph.disconnect_node(conn["from"], conn["from_port"], conn["to"], conn["to_port"])

func reconnect_slots():
	var graph = get_parent()
	for child in dnode.children:
		var child_node = graph.get_speech_node(child.name)
		for resp_idx in child.resp_indicies:
			set_slot(resp_idx+2, false, 0, ColorN("white"), true, 1, ColorN("blue"))
			graph.connect_node(name, resp_idx, child.name, 0)

func _gui_input(event):
	if not event is InputEventMouseButton:
		return
	var within_control = get_parent().get_viewport_rect().has_point(get_viewport().get_mouse_position())
	if within_control:
		if event.button_index == BUTTON_LEFT and event.doubleclick:
			var dialog = SetTextDialog.instance()
			add_child(dialog)
			dialog.node = self
			dialog.popup_centered()
			accept_event()
		elif event.button_index == BUTTON_RIGHT:
			accept_event()

func _dragged(from, to):
	dnode.pos = to

func _set_text(val):
	text = val
	var tr = tr(text)
	_say.text = tr if tr else text
	dnode.text = text
	emit_signal("node_updated", dnode)

func _set_dnode(val):
	if not val:
		dnode = null
		return
	if dnode and dnode.name == val.name:
		return 
	dnode = val
	_set_id(val.id)
	_set_text(val.text)
	name = val.name
	offset = val.pos
	for resp in val.responses:
		add_response(resp, false)

func _set_id(val):
	title = val
	dnode.id = val
	emit_signal("node_updated", dnode)

func _get_id():
	return title

func _resize_request(new_minsize):
	self.rect_size = new_minsize
	
func _close_request():
	var graph = get_parent()
	var conns = graph.get_connection_list()
	for conn in conns:
		if conn["from"] == name or conn["to"] == name:
			graph._disconnect_request(conn["from"], conn["from_port"], conn["to"], conn["to_port"])
			#graph.emit_signal("disconnection_request", conn["from"], conn["from_port"], conn["to"], conn["to_port"])
	graph.remove_child(self)
	queue_free()