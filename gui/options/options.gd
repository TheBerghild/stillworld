extends Control

@onready var v_box_container: VBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer
@onready var tab_container: TabContainer = $MarginContainer/HBoxContainer/TabContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var indicator: Sprite2D = $Indicator
@onready var default_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Button

const DEFAULT_THEME = preload("res://gui/default_theme.tres")

func _ready() -> void:
	for index in v_box_container.get_children().size():
		var button = v_box_container.get_child(index)
		button.focus_entered.connect(on_button_focus_enter.bind(button,index))
		button.focus_exited.connect(on_button_focus_exit.bind(button))
		button.pivot_offset = Vector2(0,17)
	
func on_button_focus_enter(button : Button, index: int) -> void:
	get_tree().create_tween().tween_property(button, "scale", Vector2(1.4,1.4), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	set_indicator_pos(button.global_position + Vector2(-15,17))
	tab_container.current_tab = index

func on_button_focus_exit(button : Button) -> void:
	get_tree().create_tween().tween_property(button, "scale", Vector2(1,1), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("Options"):
		change_visibility()

func set_indicator_pos(new_pos:Vector2):
	var angle = ((new_pos - self.global_position) + Vector2(300,0)).angle()
	await get_tree().create_tween().tween_property(indicator, "rotation", angle, 0.1).finished
	get_tree().create_tween().tween_property(indicator, "global_position", new_pos, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	get_tree().create_tween().tween_property(indicator, "rotation", 0, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func change_visibility():
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hide()
		animation_player.play("RESET")
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		show()
		animation_player.play("enter")
		default_button.grab_focus()
		indicator.position = Vector2(59,241)
