extends Sprite
class_name AnimatedSpriteSheet

const _IDENTITY_VECTOR := Vector2()

export var sprint_mult := 2.0
export var die_speed := 5.0
export var idle_anim_left := "Idle_Left"
export var idle_anim_right := "Idle_Right"
export var idle_anim_up := "Idle_Up"
export var idle_anim_down := "Idle_Down"
export var walk_anim_right := "Walk_Right"
export var walk_anim_left := "Walk_Left"
export var walk_anim_up := "Walk_Up"
export var walk_anim_down := "Walk_Down"
export var attack_anim_left := "Slash_Left"
export var attack_anim_right := "Slash_Right"
export var attack_anim_up := "Slash_Up"
export var attack_anim_down := "Slash_Down"
export var die_anim := "Death_Down"
export var starting_direction := Vector2(0, 1)

export var player_controlled := false

onready var _animation_player : AnimationPlayer = get_node("AnimationPlayer")

onready var _og_speed := _animation_player.playback_speed
onready var _last_direction := starting_direction
onready var _speed := _og_speed

var _last_anim : String
var _is_attacking : bool

func reset():
	if _last_anim:
		_animation_player.play(_last_anim)
		_animation_player.playback_speed = _og_speed

func move(motion : Vector2):
	if _is_attacking:
		return 
	var direction := motion.normalized()
	var anim : String
	if motion.length() == 0.0:
		anim = _get_idle_anim(_last_direction)
	else:
		anim = _get_walk_anim(direction)
		_last_direction = direction
	if anim != _last_anim and anim != "":
		_last_anim = anim
		_animation_player.play(anim, -1, _speed)

func die(creature : Creature):
	_animation_player.play(die_anim, -1, die_speed)

func set_sprint(sprint : bool):
	_speed = _og_speed*sprint_mult if sprint else _og_speed
	
func attack(weapon : Weapon):
	if _is_attacking:
		return
	var anim := _get_attack_anim(_last_direction)
	if anim != "":
		_is_attacking = true
		_animation_player.play(anim, -1, weapon.speed)

func _get_walk_anim(direction : Vector2) -> String:
	if direction.x > 0:
		return walk_anim_right
	if direction.x < 0:
		return walk_anim_left
	if direction.y > 0:
		return walk_anim_down
	if direction.y < 0:
		return walk_anim_up
	return ""

func _get_idle_anim(direction : Vector2) -> String:
	if direction.x > 0:
		return idle_anim_right
	if direction.x < 0:
		return idle_anim_left
	if direction.y > 0:
		return idle_anim_down
	if direction.y < 0:
		return idle_anim_up
	return ""

func _get_attack_anim(direction : Vector2) -> String:
	if direction.x > 0:
		return attack_anim_right
	if direction.x < 0:
		return attack_anim_left
	if direction.y > 0:
		return attack_anim_down
	if direction.y < 0:
		return attack_anim_up
	return ""

func _physics_process(delta : float):
	var motion := Vector2()
	if Input.is_action_pressed("move_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("move_down"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		motion += Vector2(1, 0)
	move(motion)

func _ready():
	if not player_controlled:
		set_physics_process(false)
	_animation_player.connect("animation_finished", self, "_animation_finished")
	move(_IDENTITY_VECTOR)

func _animation_finished(anim : String):
	match anim:
		attack_anim_left, attack_anim_right, attack_anim_up, attack_anim_down:
			_animation_player.playback_speed = _og_speed
			_is_attacking = false
			reset()
