extends Control

const SINGLE_WORLD_PANEL = preload("res://gui/main_menu/world_select/single_world_panel/single_world_panel.tscn")

@onready var container: Container = %Container
@onready var empty_label: Label = %EmptyLabel
@onready var popup: PanelContainer = $Popup
@onready var name_text: LineEdit = %NameText
@onready var seed_text: LineEdit = %SeedText
@onready var confirm: ConfirmationDialog = %Confirm
@onready var accept_dialog: AcceptDialog = %AcceptDialog

var deleting_save : String

func _ready() -> void:
	var user_dir = DirAccess.open("user://")
	if not user_dir.dir_exists("saves"):
		user_dir.make_dir("saves")
	read_worlds()

func _on_open_folder_pressed() -> void:
	OS.shell_show_in_file_manager(ProjectSettings.globalize_path("user://saves"))

func read_worlds():
	for child in container.get_children(): child.queue_free()
	var dir = DirAccess.open("user://saves")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var is_empty := true
	while file_name != "":
		if dir.current_is_dir():
			is_empty = false
			var new_panel = SINGLE_WORLD_PANEL.instantiate()
			new_panel.dir_name = file_name
			var config = ConfigFile.new()
			var err = config.load("user://saves/%s/data.still"%file_name)
			if err == OK:
				new_panel.play_time = time_convert(config.get_value("save_data", "play_time",0))
			new_panel.DeleteRequested.connect(delete_request.bind(file_name))
			new_panel.PlayRequested.connect(play_save.bind(file_name))
			container.add_child(new_panel)
		file_name = dir.get_next()
	if is_empty:
		empty_label.show()
	else:
		empty_label.hide()

func delete_request(save_name: String):
	confirm.get_cancel_button().call_deferred("grab_focus")
	confirm.title = "DELETE %s" %save_name
	confirm.dialog_text = "Are you sure want to delete \"%s\"?\nIt will delete all files in folder and they will be gone forever (very long time)." %save_name
	confirm.show()
	deleting_save = save_name
	
func _on_confirm_confirmed() -> void:
	for file in DirAccess.get_files_at("user://saves/%s"%deleting_save):  
		DirAccess.remove_absolute("user://saves/%s/%s"%[deleting_save, file])
	var dir = DirAccess.open("user://saves")
	dir.remove(deleting_save)
	deleting_save = ""
	read_worlds()

func play_save(save_name: String):
	GameSaver.save_path = ProjectSettings.globalize_path("user://saves/%s"%save_name)
	GameSaver.load_game()

func _on_popup_pressed() -> void:
	popup.show()

func _on_create_pressed() -> void:
	if name_text.text == "": return
	var dir = DirAccess.open("user://saves")
	#if dir.dir_exists(name_text.text): return
	if name_text.text.begins_with("."):
		accept_dialog.show()
		accept_dialog.dialog_text = "Could not create world.\nFolder name cannot start with a dot"
		return
	var error = dir.make_dir(name_text.text)
	if error == OK:
		var config = ConfigFile.new()
		if seed_text.text == "":
			config.set_value("save_data","seed",randi())
		else:
			config.set_value("save_data","seed",seed_text.text)
		config.save("user://saves/%s/data.still"%name_text.text)
	else:
		accept_dialog.show()
		accept_dialog.dialog_text = "Could not create world.\n%s" %error_string(error)
	popup.hide()
	read_worlds()
	name_text.clear()
	seed_text.clear()

func _on_cancel_pressed() -> void:
	popup.hide()

func time_convert(time_in_sec) -> String:
	var minutes = (time_in_sec/60)%60
	var hours = (time_in_sec/60)/60
	
	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d" % [hours, minutes]

