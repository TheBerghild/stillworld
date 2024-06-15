extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tppointindoor: Marker3D = $walls/tppointindoor
@onready var tppointoutdoor: Marker3D = $tppointoutdoor
@onready var walls: Node3D = $walls


func _on_interactable_component_screen_status_changed(is_on_screen: bool) -> void:
	if animation_player.current_animation == "die": return
	animation_player.stop()
	if is_on_screen:
		animation_player.play("doors_open")
	else:
		animation_player.play("doors_close")


func _on_enter_interactable_component_interacted() -> void:
	Autoload.Teleport.emit(tppointindoor.global_position)
	walls.show()
func _on_exit_interactable_component_interacted() -> void:
	Autoload.Teleport.emit(tppointoutdoor.global_position)
	walls.hide()
