class_name RaceData
extends Resource

enum RACE_TYPE { TIME_ATTACK }

@export var track_packed : PackedScene = null

@export var race_type : RACE_TYPE = RACE_TYPE.TIME_ATTACK
@export var lap_count : int = 3

# starting grid goes here

func _init(
		track_in:PackedScene, race_type_in:RACE_TYPE, 
		lap_count_in:int
		):
	
	track_packed = track_in
	race_type = race_type_in
	lap_count = lap_count_in
