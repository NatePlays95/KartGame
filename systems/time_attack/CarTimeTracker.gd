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
	var split = current_time
	if lap_times.size() > 0:
		split -= lap_times.reduce(func(a, n): return a+n, 0)
	
	lap_times.push_back(split)
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
	var str : String = "%02d" % minutes
	str += ":%02d" % seconds
	str += ".%03d" % millis
	return str



func _on_car_completed_lap(car_in:SimpleRaycastCar, new_lap:int, max_laps:int):
	if car_in != car: return
	split()


func _on_begin_race():
	start_timer()

func _on_end_race():
	stop_timer()
