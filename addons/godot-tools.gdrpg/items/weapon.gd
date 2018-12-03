extends Node2D
class_name Weapon

const _MAX_DAMAGE := 9999.0
const _STEEPNESS_COEFFICIENT := 0.27
const _SIGMONDS_MIDPOINT_X := 26.6

export var weapon_rating : int = 6
export var speed := 2.0

signal attack


func _ready():
	randomize()
	$HitBox.connect("area_entered", self, "_attack_landed")
	

func make_attack():
	emit_signal("attack", self)

func _calculate_damage(attack : float, def : float) -> float:
	var roll = rand_range(0.1, weapon_rating)
	return MathUtil.logistic(_MAX_DAMAGE, roll+attack, _STEEPNESS_COEFFICIENT, _SIGMONDS_MIDPOINT_X) - def

func _attack_landed(target : HurtBox):
	var creature := target.creature
	var dmg := _calculate_damage(creature.weapon_attack(), creature.defense([]))
	creature.hp -= dmg