extends Node3D
##Holds a single chunk
class_name Chunk

signal ChunkDataUpdated

var DESERT_PLANE = load("res://game/chunk/biomes/desert/desert_plane.tscn")
var PLAINS_PLANE = load("res://game/chunk/biomes/plains/plains_plane.tscn")
const OCEAN_PLANE = preload("res://game/chunk/biomes/ocean/ocean_plane.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var container: Node3D = $Objects

##ChunkData that will be used when the chunk is loaded 
@export var chunk_data: ChunkData

var pos : Vector2i

func _ready() -> void:
	animation_player.play_backwards("fade")
	match chunk_data.biome:
		0:
			var ground = PLAINS_PLANE.instantiate()
			add_child(ground)
		1:
			var ground = DESERT_PLANE.instantiate()
			add_child(ground)
		2:
			var ground = OCEAN_PLANE.instantiate()
			add_child(ground)
	for index in chunk_data.objects.size():
		spawn_object(index)

func spawn_object(index : int) -> void:
	var object = chunk_data.objects[index]
	var new_scene : Node = object.scene.instantiate()
	container.add_child(new_scene)
	new_scene.position = Vector3(object.position.x,0,object.position.y)
	if new_scene.has_user_signal("ObjectDeleted"):
		new_scene.connect("ObjectDeleted",delete_object.bind(index))

func delete_object(index : int):
	DebugMenu.print_to_menu("DeletedObjcet",str(index))
	chunk_data.objects.remove_at(index)
	ChunkDataUpdated.emit(pos,chunk_data)

func unload():
	animation_player.play("fade")
	await animation_player.animation_finished
	queue_free()
