extends Node2D

const Context = preload("res://addons/godot-tools.gdrpg/ai/behaviors/context.gd")
const Error = preload("res://addons/godot-tools.gdrpg/ai/behaviors/error.gd")

func _ready():
	if get_child_count() > 1:
		var msg = str("[ERR]: Behavior trees should only have one child, but ", name, " has ", get_child_count(), ".")
		return Error.new(self, msg) 

func tick(actor, blackboard, delta):
	var ctx = Context.new(self, actor, blackboard, delta)
	var result = FAILED
	for child in get_children():
		result = child._execute(ctx)

	var last_open = blackboard.get(blackboard._OPEN_NODES_KEY, self)
	var curr_open = ctx.open_nodes

	# close dangling nodes
	for node in last_open:
		if !curr_open.has(node):
			node._close(ctx)

	# update blackboard
	blackboard.set(blackboard._OPEN_NODES_KEY, curr_open, self)
	return result
