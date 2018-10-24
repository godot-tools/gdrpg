extends KinematicBody2D

export(Resource) var stats
export var starting_direction = Vector2(0, 1)
export var start_dead = false
export var allow_sprint = true

var is_sprinting = false setget _set_sprint

signal dead
signal moved
signal sprint_state_changed

func move_and_update(motion):
	var is_sprinting = allow_sprint and Input.is_action_pressed("sprint") and stats.attributes.stam > 0.0
	var speed_mult = stats.sprint_multi if is_sprinting else 1.0
	_set_sprint(is_sprinting)
	motion = motion * stats.speed * speed_mult
	move_and_slide(motion)
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
		return

func _check_stamina(motion):
	var l = motion.length()
	if l > 0.0 and is_sprinting:
		stats.attributes.stam -= stats.sprint_cost
	elif l == 0.0 or not is_sprinting:
		stats.tick()

func _set_sprint(val):
	if not allow_sprint:
		return
	is_sprinting = val
	emit_signal("sprint_state_changed", val)
	
