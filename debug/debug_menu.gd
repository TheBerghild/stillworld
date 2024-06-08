extends PanelContainer

@onready var example_label: Label = $ExampleLabel
@onready var labels: VBoxContainer = $MarginContainer/VBoxContainer

func _ready() -> void:
	$MarginContainer/VBoxContainer/SpinBox.call_deferred("grab_focus")

func print_to_menu(key : String, value : String) -> void:
	var label : Label = labels.get_node(key)
	if not label:
		label = example_label.duplicate()
		label.name = key
		label.show()
		labels.add_child(label)
	label.text = "%s: %s"%[key, value]


func _on_button_pressed() -> void:
	Autoload.ShakeCamera.emit($MarginContainer/VBoxContainer/SpinBox.value)
