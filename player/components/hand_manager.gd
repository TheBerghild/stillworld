extends Node

@export var bone : BoneAttachment3D
@export var attacker : Node
@export var anim_tree : AnimationTree

var is_armed : bool = false

func _ready() -> void:
	update_hand()
	Autoload.PlayerHandUpdated.connect(update_hand)
	Autoload.player_inventory.Modified.connect(update_hand)
	

func update_hand() -> void:
	for child in bone.get_children():
		child.queue_free()
	var held_slot = Autoload.player_inventory.slot_datas[Autoload.player_hand_slot_index]
	if held_slot == null: 
		is_armed = false
		return
	if held_slot.item_data.attack_data == null:
		is_armed = false
	else:
		is_armed = true
	bone.add_child(held_slot.item_data.mesh.instantiate())
	attacker.attack_data = held_slot.item_data.attack_data
