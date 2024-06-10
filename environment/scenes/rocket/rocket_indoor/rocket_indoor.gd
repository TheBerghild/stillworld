extends Node3D


func _on_exit_body_entered(body: Node3D) -> void:
	TransitionManager.transition_to_file("res://game/game.tscn")
