extends Resource

class_name LootData

@export var slot_data : SlotData
@export var quantity_randomization : int

func get_loot_as_slot() -> SlotData:
	var new_sd = SlotData.new()
	new_sd.item_data = slot_data.item_data
	new_sd.quantity = randi_range(slot_data.quantity - quantity_randomization, slot_data.quantity + quantity_randomization)
	return new_sd
