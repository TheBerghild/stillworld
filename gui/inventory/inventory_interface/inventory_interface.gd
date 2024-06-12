extends Control

@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var player_inventory: PanelContainer = $PlayerInventory 

var click = InputEventMouseButton.new()

func _ready() -> void:
	click.pressed = true
	get_viewport().gui_focus_changed.connect(on_gui_focus_change)
	
func on_slot_click(clicked_slot):
	var temp = grabbed_slot.slot_data
	grabbed_slot.set_slot_data(clicked_slot.slot_data)
	clicked_slot.set_slot_data(temp)
	if grabbed_slot.slot_data:
		grabbed_slot.show()
	else:
		grabbed_slot.hide()

func _process(delta: float) -> void:
	if Autoload.is_joy_mode: return
	grabbed_slot.global_position = get_viewport().get_mouse_position()
	
	#debug inventory printer
	#for slot_data in Autoload.player_inventory.slot_datas:
		#if slot_data:
			#DebugMenu.print_to_menu(slot_data.item_data.name,str(slot_data.quantity))

func on_gui_focus_change(element):
	get_tree().create_tween().tween_property(grabbed_slot, "global_position", element.global_position + Vector2(0,64), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ToggleInventory"):
		if visible:
			#BUG save grabbed slot data to inventory so items persists correcctly between scenes
			Autoload.input_mode = Autoload.input_modes.GAME
			visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			player_inventory.populate_grid(Autoload.player_inventory)
			Autoload.input_mode = Autoload.input_modes.INVENTORY
			visible = true
			if Autoload.is_joy_mode:
				Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
