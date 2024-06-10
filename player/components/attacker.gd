extends Node

@export var area_3d: Area3D
@export var attack_data : AttackData

func attack():
	if not area_3d.has_overlapping_bodies(): return
	var targets = area_3d.get_overlapping_bodies()
	if attack_data.is_splash:
		for target in targets:
			target.get_node("AttackReceiver").hit(attack_data.calculate_damage())
	else:
		targets[0].get_node("AttackReceiver").hit(attack_data.calculate_damage())
