extends Node

class_name AttackReceiver

@export var root : Node
@export var max_health : int
@export var text : String

var health:
	set(new_health):
		health = new_health
		if new_health < 1:
			root.die()
		if new_health != max_health:
			Autoload.EnemyDamaged.emit(text,(health*100/max_health))
		
func hit(damage : int):
	root.hit()
	health -= damage
	
func _ready() -> void:
	health = max_health
