extends Control

@export var start_button: Button

func _on_start_button_pressed() -> void:
	TransitionManager.transition_to_file("res://game/game.tscn")

func _ready() -> void:
	start_button.call_deferred("grab_focus")
