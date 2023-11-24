extends Node


var track_options = [
	{"file": "res://scenes/tracks/test/mario_circuit.tscn", "name": "circuit", "laps": 3},
	{"file": "res://scenes/tracks/test/new_york_minute.tscn", "name": "city", "laps": 5},#change to 5
	{"file": "res://scenes/tracks/test/physics_test.tscn", "name": "physics_test", "laps": 1}
]
var track_pictures = [
	preload("res://images/prototype_textures/png/grass.png"),
	preload("res://images/prototype_textures/png/concrete.png"),
	preload("res://images/prototype_textures/png/purple.png")
]
var track_records = {
	#"circuit": {"flap":10000.00, "best":10000.00},
	#"city": {"flap":20000.00, "best":10000.00},
	#"physics_test": {"flap":0, "best":0},
}


func _ready():
	%vbox_tracks.get_children()[0].grab_focus()
	try_load_records()


func try_load_records():
	var full_records_file = load_records_file()
	if full_records_file == null: 
		print_debug("Couldn't load records file.")
		full_records_file = {}
	
	for o in track_options:
		var name = o["name"]
		if not full_records_file.has(name):
			track_records[name] = {"flap":-1, "best":-1}
			continue
		var record = {}
		record["flap"] = full_records_file[name]["flap"]
		record["best"] = full_records_file[name]["best"]
		track_records[name] = record


func load_records_file():
	#browser, check for cookies
	if not OS.is_userfs_persistent():
		print_debug("ERROR: Couldn't access browser cookies.")
		return null
	#browser and desktop saves work the same way
	if not FileAccess.file_exists("user://track_records.save"):
		print_debug("ERROR: There's no track_records.save file to load.")
		return null
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var records_file = FileAccess.open("user://track_records.save", FileAccess.READ)
	var full_records_data = {}
	# each line is a single record for a single track
	while records_file.get_position() < records_file.get_length():
		var json_string = records_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var current_data = json.get_data()
		full_records_data[current_data["name"]] = current_data
	return full_records_data


func timer_formatted(time_in:float) -> String:
	if time_in < 0:
		return "NO DATA"
	
	var minutes:int = floor(time_in/60.0)
	if minutes > 99: return "99:99:999"
	var seconds:int = floor(time_in) - minutes*60
	var millis:int = floor((time_in - minutes*60 - seconds)*1000)
	var s : String = "%02d" % minutes
	s += ":%02d" % seconds
	s += ".%03d" % millis
	return s


## TODO: change to final flow (go button, loading screen)
func select_track(scenepath:String, name:String, laps:int) -> void:
	MainMenuManager.selected_track = scenepath
	MainMenuManager.selected_track_name = name
	MainMenuManager.selected_laps = laps
	
	MainMenuManager.setup_race()


func focus_track(index) -> void:
	if track_records == {}:
		focus_track.call_deferred(index)
		return
	
	%track_picture.texture = track_pictures[index]
	
	var name = track_options[index]["name"]
	%label_flap.text = "FLAP:  "
	%label_flap.text += timer_formatted(track_records[name]["flap"])
	%label_best.text = "BEST:  "
	%label_best.text += timer_formatted(track_records[name]["best"])


func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/menus/select_car.tscn")


func _on_btn_pressed(index:int):
	select_track(track_options[index]["file"],track_options[index]["name"],track_options[index]["laps"])


func _on_btn_focus_entered(index:int):
	focus_track(index)

