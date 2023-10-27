extends Node


var current_race : RaceData = null
var ready_to_start : bool = false #for multiplayer/online


func setup_race(race:RaceData):
	current_race = race
	ready_to_start = false
	# starting grid goes in racedata
	# place transitions here
	get_tree().change_scene_to_packed(race.track_packed)






func start_race():
	set_all_cars_can_input(false)
	
	#camera flydowns go here
	
	#countdown goes here
	await get_tree().create_timer(2.0, false).timeout
	
	set_all_cars_can_input(true)
	_on_begin_race()




func handle_car_finish(car:SimpleRaycastCar):
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
signal begin_race #laps, etc
func _on_begin_race():
	begin_race.emit()

signal end_race
func _on_end_race():
	end_race.emit()

signal car_completed_lap(car:SimpleRaycastCar, new_lap:int, max_laps:int)
func _on_car_completed_lap(car:SimpleRaycastCar, new_lap:int):
	car_completed_lap.emit(car, new_lap, current_race.lap_count)
	
	if new_lap > current_race.lap_count:
		handle_car_finish(car)