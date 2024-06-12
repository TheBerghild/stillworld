extends Node

const SEED = "ober <3 Godot"
const TREE = preload("res://environment/scenes/tree/tree.tscn")
const CACTUS = preload("res://environment/scenes/cactus/cactus.tscn")
var rng = RandomNumberGenerator.new()
@export var noise : FastNoiseLite
var scatter_objects = [TREE, CACTUS]

func _ready() -> void:

	#noise = FastNoiseLite.new()
	#noise.seed = hash(SEED)
	#noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	#noise.frequency = 1
	#noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	#noise.cellular_distance_function = FastNoiseLite.DISTANCE_HYBRID
	#noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	#noise.cellular_jitter = 1
	#noise.domain_warp_enabled = false
	rng.seed = hash(SEED)

func generate_chunk_data(pos : Vector2i) -> ChunkData:
	var new_chunk_data := ChunkData.new()
	var a = noise.get_noise_2d(pos.x*0.2,pos.y*0.2)
	if a < 0.3:
		new_chunk_data.objects = scatter(0)
		new_chunk_data.biome = 0
	elif a < 0.5:
		new_chunk_data.objects = scatter(1)
		new_chunk_data.biome = 1
	else:
		new_chunk_data.biome = 2

	return new_chunk_data

func scatter(type : int):
	var objects : Array[ChunkObject]
	for i in rng.randi_range(0, 1):
		var tree = ChunkObject.new()
		tree.scene = scatter_objects[type]
		tree.position.x = rng.randf_range(8.7,-8.7)
		tree.position.y = rng.randf_range(8.7,-8.7)
		objects.append(tree)
	return objects
