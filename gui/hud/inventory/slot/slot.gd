extends PanelContainer

class_name Slot

signal SlotClicked


@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel
@onready var button: Button = $MarginContainer/Button

var inventory_reference : InventoryData
var inventory_index : int
var slot_data : SlotData

func _ready() -> void:
	if Autoload.is_joy_mode == false:
		button.focus_mode =Control.FOCUS_NONE

func set_slot_data(new_slot_data : SlotData) -> void:
	slot_data = new_slot_data
	refresh()

func refresh():
	if inventory_reference:
		inventory_reference.slot_datas[inventory_index] = slot_data
	if not slot_data:
		clear_slot()
		return
	texture_rect.texture = slot_data.item_data.texture
	if slot_data.quantity > 1:
		quantity_label.text = str(slot_data.quantity)
		quantity_label.show()
	else:
		quantity_label.hide()
		
func clear_slot() -> void:
	texture_rect.texture = null
	quantity_label.hide()

func focus():
	button.call_deferred("grab_focus")

func _on_button_button_down() -> void:
	SlotClicked.emit()
