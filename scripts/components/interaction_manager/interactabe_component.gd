extends Area3D

signal Interacted

@export var text : String
var is_on_screen = false

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	is_on_screen = false

func _process(delta: float) -> void:
	DebugMenu.print_to_menu("IsRocketInteractOnScreen", str(is_on_screen))

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	is_on_screen = true
