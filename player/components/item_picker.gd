extends Node3D


func _on_area_3d_area_entered(area: Area3D) -> void:
	Autoload.player_inventory.add_slot_data(area.get_parent().slot_data)
	area.get_parent().die()
