extends Control

@onready var indicator: Sprite2D = $Indicator
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var indicator2: Sprite2D = $Indicator2

@export var start_button: Button

var sw : int
func _on_start_button_pressed() -> void:
	TransitionManager.transition_to_file("res://gui/main_menu/world_select/world_select.tscn")

func _ready() -> void:
	sw = get_viewport_rect().size.x
	start_button.call_deferred("grab_focus")
	for index in v_box_container.get_children().size():
		var button = v_box_container.get_child(index)
		button.focus_entered.connect(on_button_focus_enter.bind(button,index))
		button.focus_exited.connect(on_button_focus_exit.bind(button))
		button.pivot_offset = Vector2(460,40)
	
func on_button_focus_enter(button : Button, index: int) -> void:
	get_tree().create_tween().tween_property(button, "scale", Vector2(1.4,1.4), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	set_indicator_pos(button.global_position.y)

func on_button_focus_exit(button : Button) -> void:
	get_tree().create_tween().tween_property(button, "scale", Vector2(1,1), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func set_indicator_pos(new_pos: int):
	var angle = (Vector2(sw/2,new_pos+40) - indicator.global_position).angle()
	var angle2 = (Vector2(sw/2,new_pos+40) - indicator2.global_position).angle()
	angle2 = lerp_angle(PI, angle2, 1.0)
	#indicator.rotation = angle
	#indicator2.rotation = angle2
	get_tree().create_tween().tween_property(indicator, "rotation", angle, 0.1)
	await get_tree().create_tween().tween_property(indicator2, "rotation", angle2, 0.1).finished
	get_tree().create_tween().tween_property(indicator, "global_position", Vector2(700,40 + new_pos) , 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	get_tree().create_tween().tween_property(indicator2, "global_position",Vector2(1220,40 + new_pos), 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	get_tree().create_tween().tween_property(indicator, "rotation", 0, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	get_tree().create_tween().tween_property(indicator2, "rotation", PI, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
