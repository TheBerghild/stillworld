extends Node

@export var area_3d: Area3D
var attack_data : AttackData
@export var default_attack : AttackData

func attack():
	
	var targets = area_3d.get_overlapping_bodies()
	if targets.is_empty(): return
	if not attack_data:
		var attack_receiver = targets[0].get_node("AttackReceiver")
		if is_instance_valid(attack_receiver):
			attack_receiver.hit(default_attack)
		return
	if attack_data.is_splash:
		for target in targets:
			var attack_receiver = target.get_node("AttackReceiver")
			if is_instance_valid(attack_receiver):
				attack_receiver.hit(attack_data)
	else:
		var attack_receiver = targets[0].get_node("AttackReceiver")
		if is_instance_valid(attack_receiver):
			attack_receiver.hit(attack_data)
