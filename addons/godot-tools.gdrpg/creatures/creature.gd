extends KinematicBody2D

export(Resource) var stats
export var starting_direction = Vector2(0, 1)
export var start_dead = false
export var allow_sprint = true

var is_sprinting = false setget _set_sprint

var collision_info

var _ray_node

signal dead
signal moved
signal sprint_state_changed

func move_and_collide(motion):
	.move_and_collide(motion)
	_check_stamina(motion)
	emit_signal("moved", motion)

func die():
	stats.attributes.hp = 0
	set_process(false)
	set_physics_process(false)
	emit_signal("dead", self)

func is_dead():
	return stats.attributes.hp <= 0

func _ready():
	if start_dead:
		die()

func _process(delta):
	if stats.attributes.hp <= 0:
		die()

func _physics_process(delta):
	stats.tick()

func _check_stamina(motion):
	if motion.length() > 0.0 and is_sprinting:
		stats.attributes.stam -= stats.sprint_cost

func _set_sprint(val):
	if not allow_sprint:
		return
	is_sprinting = val
	emit_signal("sprint_state_changed", val)
	
