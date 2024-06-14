extends Control
@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var main_health_bar: ProgressBar = $MarginContainer/VBoxContainer/JuiceBar/MainHealthBar
@onready var juice_bar: ProgressBar = $MarginContainer/VBoxContainer/JuiceBar
@onready var hide_timer: Timer = $HideTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_uid : int

func _ready() -> void:
	Autoload.EnemyDamaged.connect(update_healt_bar)
	Autoload.ExitedEnemyRadius.connect(hide_health_bar)

func update_healt_bar(text, percent,before,uid) ->void:
	current_uid = uid
	hide_timer.start()
	if percent < 1:
		animation_player.play_backwards("show")
	elif not visible:
		animation_player.play("show")
		main_health_bar.value = before
		juice_bar.value = before
	label.text = text
	await get_tree().create_tween().tween_property(main_health_bar,"value", percent, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).finished
	get_tree().create_tween().tween_property(juice_bar,"value", percent - 1, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func hide_health_bar(uid) ->void:
	if not current_uid == uid and uid != -1: return
	hide_timer.start()
	if visible:
		animation_player.play_backwards("show")
	
func _on_hide_timer_timeout() -> void:
	if not visible: return
	animation_player.play_backwards("show")
