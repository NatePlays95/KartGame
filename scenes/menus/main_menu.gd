extends Node



func _ready():
	%btn_1.grab_focus()



func _on_btn_1_pressed():
	var race : RaceData = RaceData.new(
		load("res://scenes/tracks/test/new_york_minute.tscn"), 
		RaceData.RACE_TYPE.TIME_ATTACK, 3
	)
	RaceManager.setup_race(race)

func _on_btn_2_pressed():
	var race : RaceData = RaceData.new(
		load("res://scenes/tracks/test/mario_circuit.tscn"), 
		RaceData.RACE_TYPE.TIME_ATTACK, 3
	)
	RaceManager.setup_race(race)


func _on_btn_quit_pressed():
	get_tree().quit()



func _on_btn_3_pressed():
	var race : RaceData = RaceData.new(
		load("res://scenes/tracks/test/wuhu_loop.tscn"), 
		RaceData.RACE_TYPE.TIME_ATTACK, 1
	)
	RaceManager.setup_race(race)
