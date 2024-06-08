extends CharacterBody3D

@onready var camera: Camera3D = $CameraPivot/Camera
@onready var camera_pivot: Node3D = $CameraPivot
@onready var mesh: Node3D = $Mesh
@onready var animation_tree: AnimationTree = $Animation/AnimationTree
@onready var gpu_particles_3d: GPUParticles3D = $Node3D/GPUParticles3D
@onready var chunk_loading_handler: Node = $"../StandaloneHandlers/ChunkLoadingHandler"

@export var is_sprinting : bool = false
@export var state : states = states.IDLE
@export var current_biome : int

enum states {IDLE, RUNNING}

var speed : float = 123
var sensitivity : int = 5

var is_mesh_facing_backwards : bool = false :
	set(new_value):
		is_mesh_facing_backwards = new_value
		if animation_tree.get("parameters/StateMachine/BlendSpace1D/blend_position") < 0:
			get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(mesh, "rotation:y", PI, 0.2).as_relative()
		else:
			get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(mesh, "rotation:y", -PI, 0.2).as_relative()		

func _physics_process(delta: float) -> void:
	velocity = calculate_velocity(delta)
	move_and_slide()
	SimpleGrass.set_player_position(global_position)

func calculate_velocity(delta : float) -> Vector3:
	var input_dir = Input.get_vector("Right", "Left", "Backward", "Forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var new_velocity : Vector3
	
	if direction:
		state = states.RUNNING
		if is_sprinting:
			animation_tree.set("parameters/TimeScale/scale", 10)
			new_velocity.x = direction.x * speed * delta * 10
			new_velocity.z = direction.z * speed * delta * 10
		else:
			animation_tree.set("parameters/TimeScale/scale", 1)
			new_velocity.x = direction.x * speed * delta
			new_velocity.z = direction.z * speed * delta
	else:
		animation_tree.set("parameters/TimeScale/scale", 1)
		state = states.IDLE
		new_velocity.x = move_toward(velocity.x, 0, speed)
		new_velocity.z = move_toward(velocity.z, 0, speed)
	
	if is_mesh_facing_backwards:
		animation_tree.set("parameters/StateMachine/BlendSpace1D/blend_position", lerp(animation_tree.get("parameters/StateMachine/BlendSpace1D/blend_position"),-input_dir.x,0.3))
	else:
		animation_tree.set("parameters/StateMachine/BlendSpace1D/blend_position", lerp(animation_tree.get("parameters/StateMachine/BlendSpace1D/blend_position"),input_dir.x,0.3))
		
	if is_mesh_facing_backwards and input_dir.y < 0:
		is_mesh_facing_backwards = false
	elif !is_mesh_facing_backwards and input_dir.y > 0:
		is_mesh_facing_backwards = true
	
	return new_velocity

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / (sensitivity * 10)

	if event.is_action_pressed("Sprint"):
		gpu_particles_3d.emitting = true
		is_sprinting = true
	elif event.is_action_released("Sprint"):
		gpu_particles_3d.emitting = false
		is_sprinting = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("Sprint"):
		match chunk_loading_handler.chunk_datas[chunk_loading_handler.player_chunk_pos].biome:
			0:
				gpu_particles_3d.process_material.set("color", lerp(gpu_particles_3d.process_material.get("color"), Color.DARK_OLIVE_GREEN, 0.1))
			1:
				gpu_particles_3d.process_material.set("color", lerp(gpu_particles_3d.process_material.get("color"), Color.DARK_KHAKI, 0.1))
