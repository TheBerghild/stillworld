extends Node

signal SaveLoaded

var chunk_datas = {}
var save_path : String
var save_data = {}

func save_game():
	var new_world_data = WorldData.new()
	new_world_data.chunk_datas = chunk_datas
	print(str(ResourceSaver.save(new_world_data, save_path + "/world.tres")))
	print(str(ResourceSaver.save(Autoload.player_inventory, save_path + "/player_inv.tres")))
	save_save_data()

func save_save_data():
	get_tree().call_group("Save","save")
	var config = ConfigFile.new()
	for key in save_data:
		config.set_value("save_data",key,save_data[key])
	config.save(save_path + "/data.still")

func load_game():
	if not DirAccess.dir_exists_absolute(save_path): return
	var loaded_inv_data = load(save_path + "/player_inv.tres")
	if loaded_inv_data: Autoload.player_inventory = loaded_inv_data
	else: Autoload.player_inventory = load("res://test_inventory.tres")
	var loaded_world_data = load(save_path + "/world.tres")
	if loaded_world_data:
		chunk_datas = loaded_world_data.chunk_datas
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load(save_path + "/data.still")

	# If the file didn't load, ignore it.
	if err != OK:
		return
	
	
	save_data["play_time"] = config.get_value("save_data","play_time",0)
	save_data["seed"] = config.get_value("save_data","seed")
	save_data["player_pos"] = config.get_value("save_data","player_pos",Vector3(0,0,0))
	SaveLoaded.emit()
	TransitionManager.transition_to_file("res://game/game.tscn")
