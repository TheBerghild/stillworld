extends Node3D

class_name AttackReceiver

@export var root : Node
@export var max_health : int
@export var text : String
@export var detection_area : Area3D

var uid : int

var health:
	set(new_health):
		if new_health < 1:
			root.die()
		health = new_health

func hit(damage : int):
	root.hit()
	Autoload.EnemyDamaged.emit(text,((health-damage)*100)/max_health,(health*100)/max_health,uid)
	health -= damage
	
func _ready() -> void:
	health = max_health
	uid = abs(randi())
	detection_area.body_entered.connect(on_enter)
	detection_area.body_exited.connect(on_exit)
	
func on_enter(_trash):
	Autoload.ExitedEnemyRadius.emit(-1)

func on_exit(_trash):
	Autoload.ExitedEnemyRadius.emit(uid)
