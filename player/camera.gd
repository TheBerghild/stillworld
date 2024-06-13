extends Camera3D
@onready var player: CharacterBody3D = $"../.."
@onready var camera_pivot: Node3D = $".."
@onready var camera = self
@onready var initial_rotation := rotation_degrees as Vector3

@export var trauma_reduction_rate := 1.0
@onready var node_3d: Node3D = $"../Node3D"

@export var max_x := 10.0
@export var max_y := 10.0
@export var max_z := 5.0
@export var noise : FastNoiseLite
@export var noise_speed := 50.0

var trauma := 0.0

var time := 0.0

func _ready():
	Autoload.ShakeCamera.connect(add_trauma)

func _process(delta):
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	camera.rotation_degrees.x = (initial_rotation.x) + max_x * get_shake_intensity() * get_noise_from_seed(0)
	camera.rotation_degrees.y = (initial_rotation.y) + max_y * get_shake_intensity() * get_noise_from_seed(1)
	camera.rotation_degrees.z = (initial_rotation.z) + max_z * get_shake_intensity() * get_noise_from_seed(2)
	
func _physics_process(delta: float) -> void:
	camera_pivot.rotation.y = player.rotation.y
	camera_pivot.global_position = lerp(camera_pivot.global_position, player.global_transform.origin, 5 *delta)
	node_3d.look_at(player.global_position)
	initial_rotation = node_3d.rotation_degrees
func add_trauma(trauma_amount : float):
	trauma = clamp(trauma + trauma_amount, 0.0, 1.0)

func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(_seed : int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)

