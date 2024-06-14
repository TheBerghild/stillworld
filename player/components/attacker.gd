extends Node

@export var area_3d: Area3D
@export var attack_data : AttackData

func attack():
	var targets = area_3d.get_overlapping_bodies()
	if targets.is_empty(): return
	if not attack_data:
		var attack_receiver = targets[0].get_node("AttackReceiver")
		if is_instance_valid(attack_receiver):
			attack_receiver.hit(1)
		return
	if attack_data.is_splash:
		for target in targets:
			var attack_receiver = target.get_node("AttackReceiver")
			if is_instance_valid(attack_receiver):
				attack_receiver.hit(attack_data.calculate_damage())
	else:
		var attack_receiver = targets[0].get_node("AttackReceiver")
		if is_instance_valid(attack_receiver):
			attack_receiver.hit(attack_data.calculate_damage())
