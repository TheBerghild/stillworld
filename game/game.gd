extends Node3D

signal Loaded

@onready var chunk_loader: Node = $StandaloneHandlers/ChunkLoader
@onready var player: CharacterBody3D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	chunk_loader.calculate_chunks(Vector2i(0,0), 3) #TODO make 5 ceili(sensitivity/2)
	await chunk_loader.ChunksLoaded
	chunk_loader.updating = true
	player.can_move = true
	player.global_position = Vector3(0,0,0)
	Loaded.emit()

