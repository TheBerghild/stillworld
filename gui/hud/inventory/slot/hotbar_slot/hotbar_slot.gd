extends PanelContainer

var inventory_index : int
var slot_data : SlotData
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel
@onready var button: Button = $Button

func _ready() -> void:
	Autoload.PlayerHandUpdated.connect(refresh)

func _on_button_button_down() -> void:
	Autoload.player_hand_slot_index = inventory_index

func set_slot_data(new_slot_data : SlotData) -> void:
	slot_data = new_slot_data
	refresh()

func refresh():
	if Autoload.player_hand_slot_index == inventory_index:
		button.button_pressed = true
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
