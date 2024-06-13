extends Node3D

var ROCKET_INDOOR = load("res://environment/scenes/rocket/rocket_indoor/rocket_indoor.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_interactable_component_interacted() -> void:
	Autoload.EnterIndoorScene.emit(ROCKET_INDOOR)
	

func _on_interactable_component_screen_status_changed(is_on_screen: bool) -> void:
	if animation_player.current_animation == "die": return
	animation_player.stop()
	if is_on_screen:
		animation_player.play("doors_open")
	else:
		animation_player.play("doors_close")
