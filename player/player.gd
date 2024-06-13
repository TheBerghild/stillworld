extends CharacterBody3D

@onready var gpu_particles_3d: GPUParticles3D = $Node3D/GPUParticles3D
@onready var chunk_loading_handler: Node = $"../StandaloneHandlers/ChunkLoader"
@onready var attacker: Node = $Components/Attacker
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var animation_tree: AnimationTree = $Animation/AnimationTree
@onready var camera_pivot: Node3D = $CameraPivot

@export var can_move := true

func _process(delta: float) -> void:
	if Autoload.input_mode != Autoload.input_modes.GAME: return
	if Input.is_action_pressed("Sprint"):
		if not chunk_loading_handler.chunk_datas.keys().has(chunk_loading_handler.player_chunk_pos):
			return
		match chunk_loading_handler.chunk_datas[chunk_loading_handler.player_chunk_pos].biome:
			0:
				gpu_particles_3d.process_material.set("color", lerp(gpu_particles_3d.process_material.get("color"), Color.DARK_OLIVE_GREEN, 0.04))
			1:
				gpu_particles_3d.process_material.set("color", lerp(gpu_particles_3d.process_material.get("color"), Color.BISQUE, 0.04))
	if Input.is_action_pressed("Attack") and attack_cooldown.is_stopped():
		attack_cooldown.start()
		animation_tree.set("parameters/Attack/request", 1)
	

func sync_camera():
	camera_pivot.global_position = global_position
