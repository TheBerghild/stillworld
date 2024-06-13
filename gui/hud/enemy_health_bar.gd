extends Control
@onready var label: Label = $MarginContainer/VBoxContainer/Label
@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HealthBar
@onready var hide_timer: Timer = $HideTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Autoload.EnemyDamaged.connect(update_healt_bar)

func update_healt_bar(text, percent) ->void:
	hide_timer.start()
	if percent < 1:
		animation_player.play_backwards("show")
	elif not visible:
		animation_player.play("show")
		health_bar.value = 100
	get_tree().create_tween().tween_property(health_bar,"value", percent, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	label.text = text


func _on_hide_timer_timeout() -> void:
	animation_player.play_backwards("show")
