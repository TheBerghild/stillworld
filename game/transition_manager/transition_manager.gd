extends CanvasLayer

signal Finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func close():
	animation_player.play("close")
	await animation_player.animation_finished
	Finished.emit()
	
func open():
	animation_player.play("open")
	await animation_player.animation_finished
	Finished.emit()
	
func transition_to_file(path : String):
	close()
	await Finished
	get_tree().change_scene_to_file(path)
	await get_tree().node_added
	await get_tree().current_scene.ready
	open()
