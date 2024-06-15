extends Node

signal ChunksLoaded

const CHUNK = preload("res://game/chunk/chunk.tscn")
const CHUNK_SIZE = 18

@onready var player: CharacterBody3D = $"../../Player"
@onready var chunks: Node3D = $"../../Chunks"
@onready var chunk_generator: Node = $"../ChunkGenerator"

var updating := false
var render_distance := 10

var player_chunk_pos : Vector2i :
	set(new_pos):
		if new_pos == player_chunk_pos: return
		player_chunk_pos = new_pos
		if not updating: return
		chunk_loading_password = Engine.get_frames_drawn()
		calculate_chunks(player_chunk_pos)

## this is usedto break chunk loading if the player moved without all chunks loaded
var chunk_loading_password = 0

var loaded_chunks : Array[Vector2i]

## {Vector2i : ChunkData}
@export var fixed_chunk_datas := {}
var chunk_datas = GameSaver.chunk_datas

func _ready() -> void:
	var player_position = Vector2(player.global_position.x,player.global_position.z)
	player_chunk_pos = snap_vector(player_position)
	calculate_chunks(player_chunk_pos)
func _physics_process(delta: float) -> void:
	var player_position = Vector2(player.global_position.x,player.global_position.z)
	player_chunk_pos = snap_vector(player_position)
	DebugMenu.print_to_menu("Player Chunk", "%s , %s" %[player_chunk_pos.x, player_chunk_pos.y])
	DebugMenu.print_to_menu("Player Position", "%.3f , %.3f" %[player_position.x, player_position.y])

func calculate_chunks(player_pos : Vector2i, crd: int = -1):
	if crd == -1: crd = render_distance
	var surrounding_chunks = get_surrounding_chunks(player_chunk_pos, crd)
	var password = chunk_loading_password
	for chunk_pos in subtract_array(loaded_chunks, surrounding_chunks):
		unload_chunk(chunk_pos)
	for chunk_pos in surrounding_chunks:
		if password != chunk_loading_password: return
		if loaded_chunks.has(chunk_pos): continue
		load_chunk(chunk_pos)
		await get_tree().process_frame
	ChunksLoaded.emit()

func load_chunk(pos: Vector2i):
	if not chunk_datas.keys().has(pos):
		if fixed_chunk_datas.keys().has(pos):
			chunk_datas[pos] = fixed_chunk_datas[pos]
		else:
			chunk_datas[pos] = chunk_generator.generate_chunk_data(pos)

	loaded_chunks.append(pos)
	var new_chunk = CHUNK.instantiate()
	new_chunk.name = str(pos)
	new_chunk.chunk_data = chunk_datas[pos]
	chunks.add_child(new_chunk)
	new_chunk.global_position = Vector3(pos.x *CHUNK_SIZE, 0 ,pos.y *CHUNK_SIZE)
	new_chunk.ChunkDataUpdated.connect(on_chunk_data_update)
	
func on_chunk_data_update(pos: Vector2i, data : ChunkData):
	chunk_datas[pos] = data

func unload_chunk(pos: Vector2i):
	loaded_chunks.remove_at(loaded_chunks.find(pos))
	var chunk : Chunk = chunks.get_node(str(pos))
	chunk_datas[pos] = chunk.chunk_data
	chunk.unload()
	chunk.name = "dying"

func get_surrounding_chunks(current_tile, crd) -> Array[Vector2i]:
	var surrounding_tiles : Array[Vector2i]
	var target_tile
	for x in (crd * 2) + 1:
		for y in (crd * 2) + 1:
			target_tile = current_tile + Vector2i (x - crd, y - crd)
			surrounding_tiles.append(target_tile)
	return surrounding_tiles

func snap_vector(pos : Vector2) -> Vector2i:
	var new_vector : Vector2i
	new_vector.x = floor((pos.x + CHUNK_SIZE/2) / CHUNK_SIZE)
	new_vector.y = floor((pos.y + CHUNK_SIZE/2) / CHUNK_SIZE)
	return new_vector
	
func subtract_array(a: Array, b: Array) -> Array:
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
