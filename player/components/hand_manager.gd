extends Node

@export var bone : BoneAttachment3D
@export var attacker : Node
@export var anim_tree : AnimationTree

func _ready() -> void:
	update_hand()
	Autoload.PlayerHandUpdated.connect(update_hand)
	Autoload.player_inventory.Modified.connect(update_hand)
	

func update_hand() -> void:
	for child in bone.get_children():
		child.queue_free()
	var held_slot = Autoload.player_inventory.slot_datas[Autoload.player_hand_slot_index]
	if held_slot == null: 
		anim_tree.set("parameters/ArmState/transition_request","unarmed")
		return
	bone.add_child(held_slot.item_data.mesh.instantiate())
	attacker.attack_data = held_slot.item_data.attack_data
	if held_slot.item_data.attack_data == null:
		anim_tree.set("parameters/ArmState/transition_request","unarmed")
	else :
		anim_tree.set("parameters/ArmState/transition_request","armed")
