extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	%VBoxContainer.get_children()[0].grab_focus()

func select_car(filename):
	MainMenuManager.selected_cars = [filename]
	get_tree().change_scene_to_file("res://scenes/menus/select_track.tscn")


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_btn_1_pressed():
	select_car("res://objects/karts/test_gt2.tscn")
	pass # Replace with function body.

func _on_btn_2_pressed():
	select_car("res://objects/karts/test_westurbo.tscn")
	pass # Replace with function body.

