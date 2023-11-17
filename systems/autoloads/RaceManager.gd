extends Node


var current_race : RaceData = null
var ready_to_start : bool = false #for multiplayer/online

var ready_checkpoints : bool = false
var ready_cameras : bool = false
var ready_starting_grid : bool = false

func setup_race(race:RaceData):
	current_race = race
	
	ready_checkpoints = false
	ready_cameras = false
	ready_starting_grid = false
	# starting grid goes in racedata
	# place transitions here
	get_tree().change_scene_to_packed(race.track_packed)



func _process(_delta):
	#try to start race
	if current_race:
		if ready_checkpoints and ready_cameras and ready_starting_grid:
			ready_checkpoints = false
			ready_cameras = false
			ready_starting_grid = false
			start_race()



func start_race():
	set_all_cars_can_input(false)
	#await get_tree().create_timer(1.0, false).timeout
	
	start_intro_camera_flydown.emit()
	await self.end_intro_camera_flydown
	#await get_tree().create_timer(7.0, false).timeout
	
	begin_countdown.emit()
	
	await get_tree().create_timer(4.0, false).timeout
	
	set_all_cars_can_input(true)
	_on_begin_race()




func handle_car_finish(car:SimpleRaycastCar):
	if not current_race: return
	if current_race.race_type == RaceData.RACE_TYPE.TIME_ATTACK:
		handle_end_race()




func handle_end_race():
	_on_end_race()
	set_all_cars_can_input(false)
	await get_tree().create_timer(2.0, false).timeout
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")



func set_all_cars_can_input(value:bool):
	for car in get_tree().current_scene.get_children():
		if not car is SimpleRaycastCar: continue
		car.can_input = value




# RaceEventBus
signal start_intro_camera_flydown
signal end_intro_camera_flydown
func _on_end_intro_camera_flydown():
	end_intro_camera_flydown.emit()

signal begin_countdown

signal begin_race #laps, etc
func _on_begin_race():
	begin_race.emit()

signal end_race
func _on_end_race():
	end_race.emit()

signal car_completed_lap(car:SimpleRaycastCar, new_lap:int, max_laps:int)
func _on_car_completed_lap(car:SimpleRaycastCar, new_lap:int):
	if not current_race: return
	car_completed_lap.emit(car, new_lap, current_race.lap_count)
	
	if new_lap > current_race.lap_count:
		handle_car_finish(car)
