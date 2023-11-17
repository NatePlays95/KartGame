extends Node







func _ready():
	%vbox_select.get_children()[0].grab_focus()



func _on_btn_1_pressed():
	var race : RaceData = RaceData.new(
		load("res://scenes/tracks/test/new_york_minute.tscn"), 
		RaceData.RACE_TYPE.TIME_ATTACK, 5, []
	)
	RaceManager.setup_race(race)

func _on_btn_2_pressed():
	var race : RaceData = RaceData.new(
		load("res://scenes/tracks/test/mario_circuit.tscn"), 
		RaceData.RACE_TYPE.TIME_ATTACK, 3, []
	)
	RaceManager.setup_race(race)


func _on_btn_3_pressed():
	var race : RaceData = RaceData.new(
		load("res://scenes/tracks/test/wuhu_loop.tscn"), 
		RaceData.RACE_TYPE.TIME_ATTACK, 2, []
	)
	RaceManager.setup_race(race)



func _on_btn_quit_pressed():
	get_tree().quit()



func _on_btn_ta_pressed():
	MainMenuManager.selected_race_type = RaceData.RACE_TYPE.TIME_ATTACK
	MainMenuManager.selected_cars = ["res://objects/karts/test_westurbo.tscn"]
	get_tree().change_scene_to_file("res://scenes/menus/select_track.tscn")
