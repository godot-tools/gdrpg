extends Node

export var id = ""
export var quest_name = ""
export var complete = false

export(NodePath) var blackboard = NodePath("/root/Blackboard")

onready var _bb = get_node(blackboard)

signal quest_complete

func _ready():
	set_process(complete)

func _process(delta):
	for child in get_children():
		if not child.is_complete(_bb):
			return
	complete = true
	emit_signal("quest_complete", self)
	set_process(false)

