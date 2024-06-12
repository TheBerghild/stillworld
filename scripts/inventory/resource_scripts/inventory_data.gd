extends Resource

class_name InventoryData

@export var slot_datas : Array[SlotData]

func change_slot_at(index: int, new_slot_data : SlotData):
	slot_datas[index] = new_slot_data

func add_slot_data(slot_data_to_add : SlotData):
	for index in slot_datas.size():
		if slot_datas[index] == null: continue
		if not slot_datas[index].item_data == slot_data_to_add.item_data: continue
		if slot_datas[index].quantity == slot_datas[index].item_data.max_stack_size: continue
		
		var how_much_can_add = slot_datas[index].item_data.max_stack_size - slot_datas[index].quantity
		if how_much_can_add >= slot_data_to_add.quantity:
			slot_datas[index].quantity += slot_data_to_add.quantity
			return
		else:
			slot_datas[index].quantity = slot_datas[index].item_data.max_stack_size
			slot_data_to_add.quantity -= how_much_can_add
			continue

	for index in slot_datas.size():
		if not slot_datas[index] == null: continue
		if slot_data_to_add.quantity <= slot_data_to_add.item_data.max_stack_size:
			slot_datas[index] = slot_data_to_add
			return
		else:
			slot_datas[index] = slot_data_to_add.duplicate()
			slot_datas[index].quantity = slot_data_to_add.item_data.max_stack_size
			slot_data_to_add.quantity -= slot_data_to_add.item_data.max_stack_size
			continue
	#TODO handle inventory overflow
	#CRITICAL duplicate slot_data if you will keep working with it
