extends PanelContainer

@onready var big_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/BigLabel
@onready var small_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/SmallLabel

signal DeleteRequested
signal PlayRequested


var dir_name : String
var play_time : String = "New"

func _ready() -> void:
	big_label.text = dir_name
	small_label.text = play_time

func _on_play_button_pressed() -> void:
	PlayRequested.emit()


func _on_delete_button_pressed() -> void:
	DeleteRequested.emit()
