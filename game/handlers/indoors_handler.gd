extends Node

@onready var chunk_loader: Node = $"../ChunkLoader"
@onready var player: CharacterBody3D = $"../../Player"
@onready var chunks: Node3D = $"../../Chunks"
@onready var game: Node3D = $"../.."
@onready var indoor_scenes: Node3D = $"../../IndoorScenes"

var last_player_pos : Vector3

func _ready() -> void:
	Autoload.TeleportIndoor.connect(teleport_indoor)
	Autoload.TeleportOutdoor.connect(teleport_outdoor)

func teleport_indoor(pos : Vector3):
	last_player_pos = player.global_position
	TransitionManager.close()
	await TransitionManager.Finished
	player.global_position = pos
	chunks.hide()
	player.sync_camera()
	chunk_loader.updating = false
	TransitionManager.open()
	
func teleport_outdoor(pos : Vector3):
	TransitionManager.close()
	await TransitionManager.Finished
	player.global_position = last_player_pos
	chunks.show()
	player.sync_camera()
	chunk_loader.updating = true
	TransitionManager.open()
