extends CharacterBody3D

@onready var camera: Camera3D = $CameraPivot/Camera
@onready var camera_pivot: Node3D = $CameraPivot
@onready var mesh: Node3D = $Mesh
@onready var animation_tree: AnimationTree = $Animation/AnimationTree
@onready var gpu_particles_3d: GPUParticles3D = $Node3D/GPUParticles3D
@onready var chunk_loading_handler: Node = $"../StandaloneHandlers/ChunkLoader"
@onready var attacker: Node = $Components/Attacker
@onready var attack_cooldown: Timer = $AttackCooldown

var is_sprinting : bool = false
var state : states = states.IDLE
var current_biome : int

enum states {IDLE, RUNNING}

var speed : float = 123
var sensitivity : int = 5
var can_move := true
@export var is_indoor:= false

func _ready() -> void:
	if Autoload.player_pos != null and not is_indoor:
		global_position = Autoload.player_pos + Vector3(0,1,0)

func _physics_process(delta: float) -> void:
	DebugMenu.print_to_menu("Is On Floor", str(is_on_floor()))
	DebugMenu.print_to_menu("Player Y", str(global_position.y))
	if not is_on_floor() and global_position.y > 0:
		global_position.y = move_toward(global_position.y, 0.0, delta * 7)
	if can_move:
		velocity = calculate_velocity(delta)
		move_and_slide()
		if not is_indoor:
			Autoload.player_pos = global_position
	else:
		state = states.IDLE
	SimpleGrass.set_player_position(global_position)

func calculate_velocity(delta : float) -> Vector3:
	var input_dir = Input.get_vector("Right", "Left", "Backward", "Forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var new_velocity : Vector3 = velocity
	
	if direction:
		input_dir.x *= -1
		mesh.rotation.y = lerp_angle(mesh.rotation.y,input_dir.angle() + PI / -2, 0.3)
		state = states.RUNNING
		if is_sprinting:
			animation_tree.set("parameters/TimeScale/scale", 3)
			new_velocity.x = direction.x * speed * delta * 3
			new_velocity.z = direction.z * speed * delta * 3
		else:
			animation_tree.set("parameters/TimeScale/scale", 1)
			new_velocity.x = direction.x * speed * delta
			new_velocity.z = direction.z * speed * delta
	else:
		animation_tree.set("parameters/TimeScale/scale", 1)
		state = states.IDLE
		new_velocity.x = move_toward(velocity.x, 0, speed)
		new_velocity.z = move_toward(velocity.z, 0, speed)
	return new_velocity
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / (sensitivity * 10)
	if is_indoor: return
	if event.is_action_pressed("Sprint"):
		gpu_particles_3d.emitting = true
		is_sprinting = true
	elif event.is_action_released("Sprint"):
		gpu_particles_3d.emitting = false
		is_sprinting = false

func _process(delta: float) -> void:
	rotation.y += (Input.get_action_strength("CameraRight") - Input.get_action_strength("CameraLeft")) * sensitivity * delta/2
	if is_indoor: return
	if Input.is_action_pressed("Sprint"):
		if not chunk_loading_handler.chunk_datas.keys().has(chunk_loading_handler.player_chunk_pos):
			return
		match chunk_loading_handler.chunk_datas[chunk_loading_handler.player_chunk_pos].biome:
			0:
				gpu_particles_3d.process_material.set("color", lerp(gpu_particles_3d.process_material.get("color"), Color.DARK_OLIVE_GREEN, 0.04))
			1:
				gpu_particles_3d.process_material.set("color", lerp(gpu_particles_3d.process_material.get("color"), Color.DARK_KHAKI, 0.04))
	if Input.is_action_pressed("Attack") and attack_cooldown.is_stopped():
		attack_cooldown.start()
		animation_tree.set("parameters/Attack/request", 1)
	
