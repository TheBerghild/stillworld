extends Node

var chunk_datas = {}

func _ready() -> void:
	load_game()

func save_game():
	var new_world_data = WorldData.new()
	new_world_data.chunk_datas = chunk_datas
	print(str(ResourceSaver.save(new_world_data, "user://world.tres")))

func load_game():
	if FileAccess.file_exists("user://world.tres"):
		var world_data = ResourceLoader.load("user://world.tres")
		chunk_datas = world_data.chunk_datas.duplicate()
