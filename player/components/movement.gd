extends Node

@onready var player: CharacterBody3D = $"../.."
@onready var camera: Camera3D = $"../../CameraPivot/Camera"
@onready var camera_pivot: Node3D = $"../../CameraPivot"
@onready var mesh: Node3D = $"../../Mesh"
@onready var animation_tree: AnimationTree = $"../../Animation/AnimationTree"
@onready var gpu_particles_3d: GPUParticles3D = $"../../Node3D/GPUParticles3D"

var is_sprinting : bool = false
var state : states = states.IDLE

enum states {IDLE, RUNNING}

var speed : float = 200
var sensitivity : int = 5

func _physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.global_position.y -= 9.8 * delta
	if player.can_move:
		player.velocity = calculate_velocity(delta)
		player.move_and_slide()
		if not player.is_indoor:
			Autoload.player_pos = player.global_position
	else:
		state = states.IDLE

func calculate_velocity(delta : float) -> Vector3:
	if not Autoload.input_mode == Autoload.input_modes.GAME: 
		state = states.IDLE
		return Vector3.ZERO
	var input_dir = Input.get_vector("Right", "Left", "Backward", "Forward")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var new_velocity : Vector3 = player.velocity
	
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
		new_velocity.x = move_toward(player.velocity.x, 0, speed)
		new_velocity.z = move_toward(player.velocity.z, 0, speed)
	return new_velocity
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Autoload.input_mode == Autoload.input_modes.GAME:
		player.rotation.y -= event.relative.x / (sensitivity * 10)
	if player.is_indoor: return
	if event.is_action_pressed("Sprint"):
		gpu_particles_3d.emitting = true
		is_sprinting = true
	elif event.is_action_released("Sprint"):
		gpu_particles_3d.emitting = false
		is_sprinting = false

func _process(delta: float) -> void:
	if not Autoload.input_mode == Autoload.input_modes.GAME: return
	player.rotation.y += (Input.get_action_strength("CameraRight") - Input.get_action_strength("CameraLeft")) * sensitivity * delta/2
