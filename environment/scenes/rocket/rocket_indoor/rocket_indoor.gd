extends Node3D

func _on_interactable_component_interacted() -> void:
	Autoload.ExitIndoor.emit()
