extends Node

@onready var chunk_loader: Node = $"../ChunkLoader"
@onready var player: CharacterBody3D = $"../../Player"
@onready var chunks: Node3D = $"../../Chunks"

var last_player_pos : Vector3

func _ready() -> void:
	Autoload.EnterIndoorScene.connect(enter_scene)

func enter_scene(path):
	GameSaver.save_game
	player.can_move = false
	last_player_pos = player.global_position
	TransitionManager.transition_to_file(path)
	
