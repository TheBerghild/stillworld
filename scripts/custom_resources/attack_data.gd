extends Resource

class_name AttackData

@export var base_damage : int
@export var critical_multiplier : float
@export var critical_chance : int
@export var is_splash : bool
@export var type : weapon_types

enum weapon_types {Sword,Axe,Pickaxe,Ranged}

func calculate_damage() -> int:
	if randi_range(0, 100) <= critical_chance:
		return ceili(base_damage * critical_multiplier)
	else:
		return base_damage
