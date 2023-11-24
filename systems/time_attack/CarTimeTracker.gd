class_name CarTimeTracker
extends Node

#@export var ui_packed_scene : PackedScene = null
@export var ui_packed_scene : PackedScene = preload("res://scenes/ui/car_ui/car_ui_timer.tscn")
var ui_scene : Control = null

var current_time : float = 0
var is_timer_active : bool = false

var lap_times : Array[float] = []

@onready var car : SimpleRaycastCar = get_parent()

func _ready():
	RaceManager.begin_race.connect(_on_begin_race)
	RaceManager.end_race.connect(_on_end_race)
	RaceManager.car_completed_lap.connect(_on_car_completed_lap)
	
	#example
	if ui_packed_scene:
		ui_scene = ui_packed_scene.instantiate()
		add_child(ui_scene)
	#start_timer()


func try_save_records():
	if not RaceManager.current_race:
		print_debug("Can't save records: No race going on at the moment")
		return
	
	var name : String = RaceManager.current_race.track_name
	
	var full_records_file = load_records_file()
	if full_records_file == null: 
		print_debug("Couldn't load records file.")
		full_records_file = {}
		#return
	
	var sorted_laps = lap_times.duplicate()
	sorted_laps.sort()
	var best : float = current_time
	var flap : float = sorted_laps.front()
	
	if not full_records_file.has(name):
		full_records_file[name] = {"best":best, "flap":flap}
	else:
		full_records_file[name]["best"] = min(best, full_records_file[name]["best"])
		full_records_file[name]["flap"] = min(flap, full_records_file[name]["flap"])
	
	var save_result = save_records_file(full_records_file)
	if not save_result:
		print_debug("ERROR: Failed to save records.")
		return
	print("Records saved successfully.")


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


func save_records_file(record_data:Dictionary) -> bool:
	#browser, check for cookies
	if not OS.is_userfs_persistent():
		print_debug("ERROR: Couldn't access browser cookies.")
	
	var save_game = FileAccess.open("user://track_records.save", FileAccess.WRITE)
	for name in record_data.keys():
		var track_data = {
			"name": name, 
			"best": record_data[name]["best"],
			"flap": record_data[name]["flap"]
		}
		var json_string = JSON.stringify(track_data)
		save_game.store_line(json_string)
	
	return true


func _physics_process(delta):
	if is_timer_active:
		current_time += delta


func _process(delta):
	#print(timer_formatted())
	if ui_scene:
		ui_scene.set_current_time(timer_formatted(current_time))


func start_timer():
	lap_times = []
	current_time = 0
	is_timer_active = true

func split() -> float:
	var current_split = current_time
	if lap_times.size() > 0:
		current_split -= lap_times.reduce(func(a, n): return a+n, 0)
	
	lap_times.push_back(current_split)
	if ui_scene:
		ui_scene.set_splits(lap_times.map(timer_formatted))
	return current_time

func stop_timer() -> float:
	is_timer_active = false
	return current_time

func timer_formatted(time_in:float) -> String:
	var minutes:int = floor(time_in/60.0)
	if minutes > 99: return "99:99:999"
	var seconds:int = floor(time_in) - minutes*60
	var millis:int = floor((time_in - minutes*60 - seconds)*1000)
	var s : String = "%02d" % minutes
	s += ":%02d" % seconds
	s += ".%03d" % millis
	return s



func _on_car_completed_lap(car_in:SimpleRaycastCar, new_lap:int, max_laps:int):
	if car_in != car: return
	split()


func _on_begin_race():
	start_timer()

func _on_end_race():
	stop_timer()
	try_save_records()
