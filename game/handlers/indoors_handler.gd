extends Node

@onready var chunk_loader: Node = $"../ChunkLoader"
@onready var player: CharacterBody3D = $"../../Player"
@onready var chunks: Node3D = $"../../Chunks"
@onready var game: Node3D = $"../.."
@onready var indoor_scenes: Node3D = $"../../IndoorScenes"

var last_player_pos : Vector3

func _ready() -> void:
	Autoload.EnterIndoorScene.connect(enter_scene)
	Autoload.ExitIndoor.connect(return_to_world)

func enter_scene(scene : PackedScene):
	last_player_pos = player.global_position
	TransitionManager.close()
	await TransitionManager.Finished
	indoor_scenes.add_child(scene.instantiate())
	player.global_position = indoor_scenes.global_position
	chunks.hide()
	player.sync_camera()
	chunk_loader.updating = false
	TransitionManager.open()
	
func return_to_world():
	TransitionManager.close()
	await TransitionManager.Finished
	for child in indoor_scenes.get_children():
		child.queue_free()
	player.global_position = last_player_pos
	chunks.show()
	player.sync_camera()
	chunk_loader.updating = true
	TransitionManager.open()
