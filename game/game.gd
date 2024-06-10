extends Node3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SimpleGrass.set_interactive(true)

func _process(delta: float) -> void:
	DebugMenu.print_to_menu("Fps", str(Engine.get_frames_per_second()))	
	
func _physics_process(delta: float) -> void:
	DebugMenu.print_to_menu("Physics Fps", str	(1 / delta))	
	
