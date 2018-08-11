tool

var name = ""
var pos = Vector2()
var text = ""
var responses = []
var children = []
var resp_indicies = []

func _init(name, pos=Vector2(), text="", responses=[]):
	self.name = name
	self.pos = pos
	self.text = text
	self.responses = responses

func remove_response_at(idx, update_children=true):
	if update_children:
		for child in children:
			child.resp_indicies.erase(idx)
			for resp_idx in child.resp_indicies:
				if resp_idx > idx and not child.resp_indicies.has(idx-1):
					child.resp_indicies.push_back(idx-1)
			
			if child.resp_idx == idx:
				child.resp_idx = -1
			elif child.resp_idx > idx:
				child.resp_idx -= 1
	responses.remove(idx)

func remove_response(resp, update_children=true):
	var idx = responses.find(resp)
	if idx < 0:
		return
	remove_response_at(idx, update_children)

func remove_child_at(idx):
	children.remove(idx)

func remove_child(child):
	children.erase(child)

func has_connection(idx):
	for child in children:
		if child.resp_indicies.has(idx):
			return true
	return false

func get_child_for_resp(resp):
	var idx = resp
	if typeof(resp) != TYPE_INT:
		idx = responses.find(resp)
	if idx < 0:
		return null
	for child in children:
		for r in child.resp_indicies:
			if r == idx:
				return child
	return null
