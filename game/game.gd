extends Node3D

signal Loaded

@onready var chunk_loader: Node = $StandaloneHandlers/ChunkLoader
@onready var player: CharacterBody3D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	chunk_loader.calculate_chunks(chunk_loader.snap_vector(Vector2(Autoload.player_pos.x,Autoload.player_pos.z)), 5) #TODO make 5 ceili(sensitivity/2)
	await chunk_loader.ChunksLoaded
	chunk_loader.updating = true
	player.can_move = true
	player.global_position = Autoload.player_pos
	Loaded.emit()

func _on_session_timer_timeout() -> void:
	GameSaver.save_data["play_time"] += 10
	print(GameSaver.save_data["play_time"])
