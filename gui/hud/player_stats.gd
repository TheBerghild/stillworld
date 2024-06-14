extends Control

@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/JuiceBar/HealthBar
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var juice_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/JuiceBar

func _ready() -> void:
	Autoload.PlayerHealthChanged.connect(on_player_health_change)

func on_player_health_change(new_health) -> void:
	animation_player.play("player_hurt")
	await get_tree().create_tween().tween_property(health_bar, "value", new_health, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).finished
	get_tree().create_tween().tween_property(juice_bar, "value", new_health - 1, 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
