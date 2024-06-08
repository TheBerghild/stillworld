extends Node3D

##Holds a single chunk
class_name Chunk

var DESERT_PLANE = load("res://game/chunk/biomes/desert/desert_plane.tscn")
var PLAINS_PLANE = load("res://game/chunk/biomes/plains/plains_plane.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

##ChunkData that will be used when the chunk is loaded 
@export var chunk_data: ChunkData

func _ready() -> void:
	$Label3D.text = name
	animation_player.play_backwards("fade")
	match chunk_data.biome:
		0:
			var ground = PLAINS_PLANE.instantiate()
			add_child(ground)
		1:
			var ground = DESERT_PLANE.instantiate()
			add_child(ground)
			
func unload():
	animation_player.play("fade")
	await animation_player.animation_finished
	queue_free()
