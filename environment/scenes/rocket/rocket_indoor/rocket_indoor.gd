extends Node3D

func _on_interactable_component_interacted() -> void:
	TransitionManager.transition_to_file("res://game/game.tscn")
