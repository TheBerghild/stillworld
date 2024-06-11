extends Control

@onready var button: Button = $Button

func _on_button_pressed() -> void:
	TransitionManager.transition_to_file("res://game/game.tscn")

func _ready() -> void:
	button.call_deferred("grab_focus")
