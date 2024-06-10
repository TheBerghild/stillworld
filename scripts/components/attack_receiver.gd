extends Node

@export var root : Node
@export var health_manager : Node

func hit(damage : int):
	root.hit()
	health_manager.hit(damage)
