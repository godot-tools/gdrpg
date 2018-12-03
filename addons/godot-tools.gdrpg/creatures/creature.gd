extends KinematicBody2D
class_name Creature

# attributes
export var hp := 100.0 setget _set_hp
export var max_hp := 100.0 setget _set_max_hp
export var mp := 100.0 setget _set_mp
export var max_mp := 100.0 setget _set_max_mp
export var stam := 100.0 setget _set_stam
export var max_stam := 100.0 setget _set_max_stam

# stats
export var speed := 150.0
export var sprint_multi := 2.0
export var sprint_cost := 0.5
export var stamina_regen := 0.1

export var starting_direction := Vector2(0, 1)
export var start_dead := false
export var allow_sprint := true

var is_sprinting := false setget _set_sprint

signal dead
signal sprint_state_changed

func move_and_update(motion : Vector2):
	if is_dead():
		return
	if allow_sprint:
		if Input.is_action_just_pressed("sprint"):
			_set_sprint(true)
		elif Input.is_action_just_released("sprint") or stam <= 0.0:
			_set_sprint(false)
	var speed_mult : float = sprint_multi if is_sprinting else 1.0
	motion *= speed * speed_mult
	move_and_slide(motion)
	_check_stamina(motion)

func weapon_attack() -> float:
	return 0.0

func defense(dmg_types : Array) -> float:
	return 0.0

func die():
	hp = 0
	emit_signal("dead", self)
	_recurse_die(self)

func _recurse_die(root : Node):
	root.set_physics_process(false)
	root.set_process(false)
	for child in root.get_children():
		_recurse_die(child)

func is_dead() -> bool:
	return hp <= 0.0

func _ready():
	if start_dead:
		die()

func _process(delta : float):
	if hp <= 0.0:
		die()

func _check_stamina(motion : Vector2):
	var l : float = motion.length()
	if l > 0.0 and is_sprinting:
		stam -= sprint_cost
	elif l == 0.0 or (not Input.is_action_pressed("sprint") and not is_sprinting):
		stam += stamina_regen

# attribute setters
func _set_sprint(sprint : bool):
	if sprint:
		is_sprinting = true
		emit_signal("sprint_state_changed", is_sprinting)
	else:
		is_sprinting = false
		emit_signal("sprint_state_changed", is_sprinting)


func _set_hp(val : float):
	if val < 0:
		val = 0
	hp = min(val, max_hp)

func _set_max_hp(val : float):
	max_hp = val
	_set_hp(hp)

func _set_mp(val : float):
	if val < 0:
		val = 0
	mp = min(val, max_mp)

func _set_max_mp(val : float):
	if val < 0:
		val = 0
	max_mp = val
	_set_mp(mp)

func _set_stam(val : float):
	if val < 0:
		val = 0
	stam = min(val, max_stam)

func _set_max_stam(val : float):
	if val < 0:
		val = 0
	max_stam = val
	_set_stam(stam)
	
	
