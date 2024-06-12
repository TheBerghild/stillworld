extends Node3D

@export var slot_data : SlotData
@onready var mesh_container: Node3D = $MeshContainer
@onready var collect_area: Area3D = $CollectArea

func _ready() -> void:
	mesh_container.add_child(slot_data.item_data.mesh.instantiate())
	
func die():
	collect_area.queue_free()
	var tween = get_tree().create_tween().tween_property(self,"global_position",Autoload.player_pos,0.3).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	get_tree().create_tween().tween_property(mesh_container,"scale",Vector3.ZERO,0.3).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	await tween.finished
	queue_free()
