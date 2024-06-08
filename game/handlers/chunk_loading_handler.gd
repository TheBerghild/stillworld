extends Node

const CHUNK = preload("res://game/chunk/chunk.tscn")
const SEED = "...öç"
const CHUNK_SIZE = 16

@onready var player: CharacterBody3D = $"../../Player"
@onready var debug_menu: PanelContainer = $"../../CanvasLayer/DebugMenu"
@onready var chunks: Node3D = $"../../Chunks"

var render_distance = 4

var player_chunk_pos : Vector2i :
	set(new_pos):
		if new_pos == player_chunk_pos: return
		player_chunk_pos = new_pos
		calculate_chunks(player_chunk_pos)

var loaded_chunks : Array[Vector2i]


## {Vector2i : ChunkData}
var chunk_datas = {}

var rng = RandomNumberGenerator.new()
var noise : FastNoiseLite

func _ready() -> void:
	noise = FastNoiseLite.new()
	noise.seed = hash(SEED)
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.frequency = 1
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	noise.cellular_distance_function = FastNoiseLite.DISTANCE_HYBRID
	noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	noise.cellular_jitter = 1
	noise.domain_warp_enabled = true
	noise.domain_warp_amplitude = 30
	noise.domain_warp_type = FastNoiseLite.DOMAIN_WARP_SIMPLEX
	noise.domain_warp_fractal_type = FastNoiseLite.DOMAIN_WARP_FRACTAL_INDEPENDENT
	noise.domain_warp_fractal_gain = 0.5
	noise.domain_warp_fractal_octaves = 3
	noise.domain_warp_fractal_lacunarity = 2
	rng.seed = hash(SEED)
	
	calculate_chunks(Vector2i(0,0))
	
func _physics_process(delta: float) -> void:
	var player_position = Vector2(player.global_position.x,player.global_position.z)

	player_chunk_pos = snap_vector(player_position, CHUNK_SIZE)
	
	debug_menu.print_to_menu("Player Chunk", "%s , %s" %[player_chunk_pos.x, player_chunk_pos.y])
	debug_menu.print_to_menu("Player Position", "%.3f , %.3f" %[player_position.x, player_position.y])

func calculate_chunks(player_pos : Vector2i):
	var surrounding_chunks = get_surrounding_chunks(player_chunk_pos)
	for chunk_pos in surrounding_chunks:
		if loaded_chunks.has(chunk_pos): continue
		load_chunk(chunk_pos)
		await get_tree().process_frame
	for chunk_pos in subtract_array(loaded_chunks, surrounding_chunks):
		unload_chunk(chunk_pos)

func load_chunk(pos: Vector2i):
	loaded_chunks.append(pos)
	if not chunk_datas.keys().has(pos): 
		chunk_datas[pos] = generate_chunk_data(pos)
	var new_chunk = CHUNK.instantiate()
	new_chunk.name = "%s,%s" % [str(pos.x),str(pos.y)]
	new_chunk.chunk_data = chunk_datas[pos]
	chunks.add_child(new_chunk)
	new_chunk.global_position = Vector3(pos.x *CHUNK_SIZE, 0 ,pos.y *CHUNK_SIZE)

func unload_chunk(pos: Vector2i):
	loaded_chunks.remove_at(loaded_chunks.find(pos))
	chunks.get_node(str(pos.x)+","+str(pos.y)).unload()
	chunks.get_node(str(pos.x)+","+str(pos.y)).name = "dying"
	
func generate_chunk_data(pos : Vector2i) -> ChunkData:
	var new_chunk_data := ChunkData.new()
	var a = noise.get_noise_2d(pos.x*0.1,pos.y*0.1)
	if a > 0.5:
		new_chunk_data.biome = 1
	else:
		new_chunk_data.biome = 0
	return new_chunk_data
	
func get_surrounding_chunks(current_tile) -> Array[Vector2i]:
	var surrounding_tiles : Array[Vector2i]
	var target_tile
	for x in (render_distance * 2) + 1:
		for y in (render_distance * 2) + 1:
			target_tile = current_tile + Vector2i (x - render_distance, y - render_distance)
			surrounding_tiles.append(target_tile)
	return surrounding_tiles

func snap_vector(pos : Vector2, size : int) -> Vector2i:
	var new_vector : Vector2i
	new_vector.x = floor((pos.x + size/2) / size)
	new_vector.y = floor((pos.y + size/2) / size)
	return new_vector
	
static func subtract_array(a: Array, b: Array) -> Array:
	var result := []
	var bag := {}
	for item in b:
		if not bag.has(item):
			bag[item] = 0
		bag[item] += 1
	for item in a:
		if bag.has(item):
			bag[item] -= 1
			if bag[item] == 0:
				bag.erase(item)
		else:
			result.append(item)
	return result
