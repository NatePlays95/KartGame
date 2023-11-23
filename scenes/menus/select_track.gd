extends Node



func _ready():
	%vbox_tracks.get_children()[0].grab_focus()



## TODO: change to final flow (go button, loading screen)
func select_track(scenepath:String, laps:int) -> void:
	MainMenuManager.selected_track = scenepath
	MainMenuManager.selected_laps = laps
	
	MainMenuManager.setup_race()



func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/menus/select_car.tscn")




func _on_btn_1_pressed():
	select_track("res://scenes/tracks/test/mario_circuit.tscn",3)
	pass # Replace with function body.


func _on_btn_2_pressed():
	select_track("res://scenes/tracks/test/new_york_minute.tscn",5)
	pass # Replace with function body.


func _on_btn_3_pressed():
	select_track("res://scenes/tracks/test/wuhu_loop.tscn",2)
	pass # Replace with function body.


func _on_btn_4_pressed():
	select_track("res://scenes/tracks/test/physics_test.tscn",1)
	pass # Replace with function body.
