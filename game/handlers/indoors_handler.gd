extends Node

@onready var chunk_loader: Node = $"../ChunkLoader"
@onready var player: CharacterBody3D = $"../../Player"
@onready var chunks: Node3D = $"../../Chunks"
@onready var game: Node3D = $"../.."
@onready var indoor_scenes: Node3D = $"../../IndoorScenes"

func _ready() -> void:
	Autoload.Teleport.connect(teleport)

func teleport(pos : Vector3):
	TransitionManager.close()
	player.set_physics_process(false)
	await TransitionManager.Finished
	player.global_position = pos
	player.sync_camera()
	TransitionManager.open()
	player.set_physics_process(true)
