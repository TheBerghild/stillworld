extends PanelContainer

@onready var example_label: Label = $ExampleLabel
@onready var labels: VBoxContainer = $MarginContainer/VBoxContainer

func print_to_menu(key : String, value : String) -> void:
	var label = labels.get_node_or_null(key)
	if not label:
		label = example_label.duplicate()
		label.name = key
		label.show()
		labels.add_child(label)
	label.text = "%s: %s"%[key, value]


func _on_button_pressed() -> void:
	Autoload.ShakeCamera.emit($MarginContainer/VBoxContainer/SpinBox.value)


func _on_button_2_pressed() -> void:
	GameSaver.save_game()
	
func _process(delta: float) -> void:
	print_to_menu("Fps", str(Engine.get_frames_per_second()))	
	
func _physics_process(delta: float) -> void:
	print_to_menu("Physics Fps", str	(1 / delta))	
	
