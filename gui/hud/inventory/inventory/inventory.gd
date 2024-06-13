extends PanelContainer

const SLOT = preload("res://gui/hud/inventory/slot/slot.tscn")

@onready var item_grid : GridContainer = %ItemGrid
@onready var inventory_interface: Control = $".."

@export var focus_on_populate : bool = false

func populate_grid(inventory : InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	
	for index in inventory.slot_datas.size():
		var slot_data = inventory.slot_datas[index]
		var new_slot = SLOT.instantiate()
		new_slot.inventory_index = index
		new_slot.inventory_reference = inventory
		item_grid.add_child(new_slot)
		new_slot.SlotClicked.connect(on_slot_click.bind(new_slot))
		if focus_on_populate and index == 0:
			new_slot.call_deferred("focus")
		if not slot_data: continue
		new_slot.set_slot_data(slot_data)

func on_slot_click(clicked_slot):
	inventory_interface.on_slot_click(clicked_slot)
