extends Node


var selected_race_type : RaceData.RACE_TYPE = RaceData.RACE_TYPE.NULL
var selected_cars : Array[String] = []
var selected_track : String = ""
var selected_track_name : String = ""
var selected_laps : int = 1

func setup_race() -> void:
	var cars_packed_array = selected_cars.map(
		func l(car_path): return load(car_path)
	)
	
	var race :  = RaceData.new(
		load(selected_track), selected_track_name,
		selected_race_type, selected_laps,
		cars_packed_array
	)
	RaceManager.setup_race(race)
