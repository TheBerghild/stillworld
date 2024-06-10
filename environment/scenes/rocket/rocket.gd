extends Node3D

const ROCKET_INDOOR = "res://environment/scenes/rocket/rocket_indoor/rocket_indoor.tscn"

func _on_area_3d_body_entered(body: Node3D) -> void:
	Autoload.EnterIndoorScene.emit(ROCKET_INDOOR)
