class_name RaceData
extends Resource

enum RACE_TYPE { NULL=0, TIME_ATTACK }

@export var track_packed : PackedScene = null

@export var race_type : RACE_TYPE = RACE_TYPE.TIME_ATTACK
@export var lap_count : int = 3

@export var player_cars : Array = []
# starting grid goes here

func _init(
		track_in:PackedScene, race_type_in:RACE_TYPE, 
		lap_count_in:int,
		player_cars_in:Array
		):
	
	track_packed = track_in
	race_type = race_type_in
	lap_count = lap_count_in
	player_cars = player_cars_in.duplicate(false)
