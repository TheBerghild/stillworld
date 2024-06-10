extends Resource

class_name AttackData

@export var base_damage : int
@export var critical_multiplier : int
@export var critical_chance : int
@export var is_splash : bool

func calculate_damage() -> int:
	if randi_range(0, 100) <= critical_chance:
		return ceili(base_damage * critical_multiplier)
	else:
		return base_damage
