extends CanvasLayer

signal Finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect
@onready var sprite_2d: AnimatedSprite2D = $Control/Sprite2D
@onready var label: Label = $Control/Label

func close():
	label.text = tr("TIP%s" %randi_range(1,4))
	sprite_2d.play("loop")	
	animation_player.play("close")
	await animation_player.animation_finished
	Finished.emit()
	
func open():
	sprite_2d.stop()
	animation_player.play("open")
	await animation_player.animation_finished
	Finished.emit()
	
func transition_to_file(path : String):
	close()
	await Finished
	get_tree().unload_current_scene()
	get_tree().change_scene_to_file(path)
	await get_tree().node_added
	await get_tree().current_scene.ready
	if get_tree().current_scene.is_in_group("WaitForLoadedOnTrans"):
		await get_tree().current_scene.Loaded
	open()
