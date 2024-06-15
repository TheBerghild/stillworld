extends Node

class_name PlayerDamager

@export var attack : AttackData
@export var area : Area3D

func hit():
	if area.has_overlapping_bodies():
		Autoload.player_health -= attack.calculate_damage()
	Autoload.ShakeCamera.emit(0.3)
	
