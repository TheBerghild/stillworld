extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var indoor_spawn_pos: Node3D = $RocketIndoor/IndoorSpawnPos
@onready var outdoor_spawn_pos: Node3D = $OutdoorSpawnPos


func _on_interactable_component_screen_status_changed(is_on_screen: bool) -> void:
	if animation_player.current_animation == "die": return
	animation_player.stop()
	if is_on_screen:
		animation_player.play("doors_open")
	else:
		animation_player.play("doors_close")


func _on_enter_interactable_component_interacted() -> void:
	Autoload.TeleportIndoor.emit(indoor_spawn_pos.global_position)

func _on_exit_interactable_component_interacted() -> void:
	Autoload.TeleportOutdoor.emit(outdoor_spawn_pos.global_position)
