extends Node


var selected_race_type : RaceData.RACE_TYPE = RaceData.RACE_TYPE.NULL
var selected_car : String = ""
var selected_track : String = ""
var selected_laps : int = 1

func setup_race() -> void:
	var race : RaceData = RaceData.new(
		load(selected_track), 
		selected_race_type, selected_laps
	)
	RaceManager.setup_race(race)
