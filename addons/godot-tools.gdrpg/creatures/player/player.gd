extends "res://addons/godot-tools.gdrpg/creatures/creature.gd"

func _physics_process(delta):
	_move()
	
func _move():
	is_sprinting = allow_sprint and Input.is_action_pressed("sprint") and stats.attributes.stam > 0.0
	var motion = Vector2()
	var speed_mult = stats.sprint_multi if is_sprinting else 1.0
	if Input.is_action_pressed("move_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("move_down"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		motion += Vector2(1, 0)
		
	motion = motion.normalized() * stats.speed * speed_mult
	_set_sprint(is_sprinting)
	move_and_collide(motion)

