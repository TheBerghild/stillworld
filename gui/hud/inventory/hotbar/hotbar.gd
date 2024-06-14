extends PanelContainer

const SLOT = preload("res://gui/hud/inventory/slot/hotbar_slot/hotbar_slot.tscn")

@onready var h_box_con: HBoxContainer = $MarginContainer/HBoxCon
@onready var inventory_interface: Control = $".."

var inventory = Autoload.player_inventory

func _ready() -> void:
	populate_grid()
	Autoload.player_inventory.Modified.connect(populate_grid)

func populate_grid()-> void:
	for child in h_box_con.get_children():
		child.queue_free()
	
	for index in 6:
		var slot_data = inventory.slot_datas[index]
		var new_slot = SLOT.instantiate()
		new_slot.inventory_index = index
		h_box_con.add_child(new_slot)
		if not slot_data:
			continue
		new_slot.set_slot_data(slot_data)
		
func _on_visibility_changed() -> void:
	if is_node_ready():
		populate_grid()
		
func _input(event: InputEvent) -> void:
	if not Autoload.input_mode == Autoload.input_modes.GAME: return
	if event.is_action_pressed("HotbarNext"):
		print("next")
		Autoload.player_hand_slot_index += 1
	elif event.is_action_pressed("HotbarPrevious"):
		Autoload.player_hand_slot_index -= 1
		print("prev")
		
