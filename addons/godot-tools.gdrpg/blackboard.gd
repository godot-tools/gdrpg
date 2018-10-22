"""
Blackboard is an in-memory key-value store store for storing 
and retrieving contextual information that is to be shared 
between nodes, or that should persist across iterations of 
a single node.
"""

extends Node

const _NODE_MEM_KEY = "node_memory"
const _OPEN_NODES_KEY = "open_nodes"

var _global_mem = {}
var _tree_mem = {}

func set(key, val, tree = null, scope = null):
	"""
	set stores the value for a given key in memory, optionally provide specific context for the kvp.
	
	params:
		key: the key to be associated with the value. If key already exists in the provided context, it will be ovewritten.
		val: the value to set.
		tree: an optional behavior_tree instance to associate the kvp with. If this is null, the kvp will be availabel globally (default: null).
		scope: an optional node scope that the kvp can be associated with (default: null).
	"""
	var mem = _get_mem(tree, scope)
	mem[key] = val

func get(key, tree = null, scope = null):
	"""
	get retrieves the value for the given key from the memory store.
	
	params:
		key: the key for which to retrieve the stored value.
		tree: an optional behavior_tree instance that the kvp is expected to be associated with. If this is null, the global store will be checked (default: null).
		scope: an optional node scope that the kvp is expected to be associate with (default: null).
		
	returns: the value for the provided key within the provided context (tree and scope), or null if no value for the key exists.
	"""
	var mem = _get_mem(tree, scope)
	return mem[key] if mem.has(key) else null

func _get_tree_mem(tree):
	if !_tree_mem.has(tree):
		_tree_mem[tree] = {
			_NODE_MEM_KEY: {},
			_OPEN_NODES_KEY: {},
		}
	return _tree_mem[tree]

func _get_node_mem(tree_mem, scope):
	var mem = tree_mem[_NODE_MEM_KEY]
	if !mem.has(scope):
		mem[scope] = {}
	return mem[scope]
	
func _get_mem(tree, scope):
	var mem = _global_mem
	if tree:
		mem = _get_tree_mem(tree)
		if scope:
			mem = _get_node_mem(mem, scope)
	return mem
