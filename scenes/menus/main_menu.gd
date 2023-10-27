extends Node







func _on_btn_timetrial_pressed():
	var race : RaceData = RaceData.new(
		load("res://scenes/tracks/test/new_york_minute.tscn"), 
		RaceData.RACE_TYPE.TIME_ATTACK, 3
	)
	RaceManager.setup_race(race)

func _on_btn_quit_pressed():
	get_tree().quit()
