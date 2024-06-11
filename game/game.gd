extends Node3D

signal Loaded

@onready var chunk_loader: Node = $StandaloneHandlers/ChunkLoader

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SimpleGrass.set_interactive(true)
	chunk_loader.calculate_chunks(Vector2i(0,0), 5) #TODO make 5 ceili(sensitivity/2)
	await chunk_loader.ChunksLoaded
	Loaded.emit()
	chunk_loader.updating = true
