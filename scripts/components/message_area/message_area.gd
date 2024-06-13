extends Area3D

@export var message_name : StringName


func _on_body_entered(_body: Node3D) -> void:
	Autoload.SendMessage.emit(message_name)
