extends Node3D

@onready var area_3d: Area3D = $Area3D
@onready var camera: Camera3D = $"../../CameraPivot/Camera"
@onready var interaction_gui: Control = $CanvasLayer/InteractionGUI
@onready var button: Button = $CanvasLayer/InteractionGUI/PanelContainer/MarginContainer/HBoxContainer/Button
@onready var label: Label = $CanvasLayer/InteractionGUI/PanelContainer/MarginContainer/HBoxContainer/Label
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

var gui_visible = false :
	set(is_visible):
		if is_visible == gui_visible: return
		gui_visible = is_visible
		if is_visible:
			animation_player.play("show")
		else:
			animation_player.play("hide")

var current_area : Area3D = null:
	set(new_area):
		current_area = new_area
		if current_area == null: gui_visible = false
		else: 
			set_text()
			gui_visible = true

func _ready() -> void:
	area_3d.area_entered.connect(on_enter)
	area_3d.area_exited.connect(on_exit)
	button.pressed.connect(on_button_press)
	
func _physics_process(delta: float) -> void:
	if current_area == null: return
	interaction_gui.position = lerp(interaction_gui.position, camera.unproject_position(current_area.global_position), 0.1)
	search()

func search():
	var areas : Array = area_3d.get_overlapping_areas()
	if areas.is_empty():
		gui_visible = false
		current_area = null
		return
	areas.reverse()
	for area in areas:
		if not area.is_on_screen: continue
		current_area = area
		return
	#TODO Maybe sort by distance here
	gui_visible = false

func set_text():
	if current_area.text:
		label.text = current_area.text
	else:
		label.text = "Interact"

func on_enter(area) -> void:
	if current_area == null and area.is_on_screen:
		current_area = area
		interaction_gui.position = camera.unproject_position(area.global_position)
func on_exit(area) -> void:
	if current_area == area:
		search()

func on_button_press():
	if current_area:
		current_area.emit_signal("Interacted")
