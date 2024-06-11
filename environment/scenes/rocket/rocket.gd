extends Node3D

const ROCKET_INDOOR = "res://environment/scenes/rocket/rocket_indoor/rocket_indoor.tscn"

func _on_interactable_component_interacted() -> void:
	Autoload.EnterIndoorScene.emit(ROCKET_INDOOR)
