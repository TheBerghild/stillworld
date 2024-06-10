extends Node3D

@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar

@export var root : Node
@export var max_health : int

var health:
	set(new_health):
		if new_health != max_health:
			progress_bar.show()
		if new_health < 1:
			root.die()
		health = new_health
		get_tree().create_tween().tween_property(progress_bar,"value", new_health, 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func _ready() -> void:
	health = max_health
	progress_bar.hide()
	progress_bar.max_value = max_health
	progress_bar.value = max_health

func hit(damage):
	health -= damage
