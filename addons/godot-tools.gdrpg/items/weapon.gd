extends Node2D

const _STAM_COEFFICIENT = 0.01

export var damage_coefficient = 10.0
export var max_roll = 6

signal attack

func _ready():
	randomize()

func make_attack():
	emit_signal("attack")

func hit(stats):
	return _calculate_damage(stats)

func _calculate_damage(stats):
	var attrs = stats.attributes
	var roll = randi() % max_roll + 1
	return damage_coefficient * roll * attrs.stam * _STAM_COEFFICIENT


