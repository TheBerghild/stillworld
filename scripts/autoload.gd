extends Node

const DROPPED_ITEM = preload("res://game/core/dropped_item/dropped_item.tscn")

signal ShakeCamera(trauma)
signal EnterIndoorScene(scene : PackedScene)
signal ExitIndoor
signal SendMessage(message : StringName)
signal EnemyDamaged
signal ExitedEnemyRadius
signal PlayerHealthChanged
signal PlayerHandUpdated

var player_pos : Vector3
var player_health : int = 100 : set = set_player_health
var player_inventory: InventoryData = preload("res://test_inventory.tres").duplicate()
var is_joy_mode = false
var input_mode : input_modes = input_modes.GAME
enum input_modes {INVENTORY,GAME}
var input_hold_timer = Timer.new()

var new_action = InputEventAction.new()
var player_hand_slot_index : int = 0 :
	set(new):
		player_hand_slot_index = posmod(new, 6)
		PlayerHandUpdated.emit()
		DebugMenu.print_to_menu("player_hand_slot_index", str(player_hand_slot_index))

func set_player_health(new_health):
	if player_health < 1:
		GameSaver.save_game()
		TransitionManager.transition_to_file("res://gui/main_menu/main_menu.tscn")
	player_health = new_health
	PlayerHealthChanged.emit(new_health)
	DebugMenu.print_to_menu("Player Health",str(new_health))
func drop_loot(loot_data : LootData, pos : Vector3):
	var new_item = DROPPED_ITEM.instantiate()
	new_item.slot_data = loot_data.get_loot_as_slot()
	get_tree().current_scene.add_child(new_item)
	new_item.global_position = pos

func _ready() -> void:
	#TranslationServer.set_locale("tr")
	new_action.pressed = true
	input_hold_timer = Timer.new()
	input_hold_timer.one_shot = true
	input_hold_timer.wait_time = 0.2
	add_child(input_hold_timer)
	if Input.get_connected_joypads().size() > 0:
		is_joy_mode = true
	Input.joy_connection_changed.connect(func(device, is_connected):
		if is_connected: is_joy_mode = true
		else: is_joy_mode = false
		)
	
func _process(delta: float) -> void:
	DebugMenu.print_to_menu("RPP", str(player_pos.round()))
	test_focus()
	#if test_focus():
		#input_hold_timer.start()

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_right") \
	or Input.is_action_pressed("ui_left") \
	or Input.is_action_pressed("ui_up") \
	or Input.is_action_pressed("ui_down"):
		input_hold_timer.start()
	
func test_focus():
	if not input_hold_timer.is_stopped() : return false

	if Input.is_action_pressed("ui_right"):
		new_action.action = "ui_right"
		Input.parse_input_event(new_action)
		return true
	if Input.is_action_pressed("ui_left"):
		new_action.action = "ui_left"
		Input.parse_input_event(new_action)
		return true
	if Input.is_action_pressed("ui_up"):
		new_action.action = "ui_up"
		Input.parse_input_event(new_action)
		return true
	if Input.is_action_pressed("ui_down"):
		new_action.action = "ui_down"
		Input.parse_input_event(new_action)
		return true
	return false
	#if event.is_action_pressed("ui_right"):
		#var neighbor = get_viewport().gui_get_focus_owner().find_valid_focus_neighbor(SIDE_RIGHT)
		#if neighbor:
			#input_hold_timer.start()
			#neighbor.call_deferred("grab_focus")
			#return
#
	#if event.is_action_pressed("ui_left"):
		#var neighbor = get_viewport().gui_get_focus_owner().find_valid_focus_neighbor(SIDE_LEFT)
		#if neighbor:
			#input_hold_timer.start()
			#neighbor.call_deferred("grab_focus")
			#return
#
	#if event.is_action_pressed("ui_up"):
		#var neighbor = get_viewport().gui_get_focus_owner().find_valid_focus_neighbor(SIDE_TOP)
		#if neighbor:
			#input_hold_timer.start()
			#neighbor.call_deferred("grab_focus")
			#return
#
	#if event.is_action_pressed("ui_down"):
		#var neighbor = get_viewport().gui_get_focus_owner().find_valid_focus_neighbor(SIDE_BOTTOM)
		#if neighbor:
			#input_hold_timer.start()
			#neighbor.call_deferred("grab_focus")
			#return

