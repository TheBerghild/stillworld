extends Control

@onready var radial_menu_advanced: RadialMenuAdvanced = $RadialMenuAdvanced
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PieMenu") and Autoload.input_mode == Autoload.input_modes.GAME:
		animation_player.stop()
		animation_player.play("show")
	if event.is_action_released("PieMenu"):
		animation_player.stop()
		animation_player.play("hide")
