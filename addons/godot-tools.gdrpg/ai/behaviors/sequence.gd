"""
Sequence is a Composite node that ticks children until one returns
State.FAILED, State.RUNNING, or an Error.
This node succeeds when ALL of its children return State.OK.
"""

extends "res://addons/godot-tools.gdrpg/ai/behaviors/btnode.gd"

func tick(ctx):
	var result = OK

	for child in get_children():
		result = child._execute(ctx)
		if result != OK:
			break

	return result
