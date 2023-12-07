extends Node

var cars_filepaths = [
	"res://objects/karts/test_impreza.tscn",
	"res://objects/karts/test_escudo.tscn",
	"res://objects/karts/test_stratos.tscn"
]
var cars_packed_scenes = [
	preload("res://objects/karts/test_impreza.tscn"),
	preload("res://objects/karts/test_escudo.tscn"),
	preload("res://objects/karts/test_stratos.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	%VBoxContainer.get_children()[0].grab_focus()

func select_car(index):
	MainMenuManager.selected_cars = [cars_filepaths[index]]
	get_tree().change_scene_to_file("res://scenes/menus/select_track.tscn")

func spawn_car(index):
	for child in %car_marker.get_children(): 
		%car_marker.remove_child(child)
		child.queue_free()
	var car_instance : SimpleRaycastCar = cars_packed_scenes[index].instantiate()
	car_instance.can_input = false
	%car_marker.add_child(car_instance)
	%camera.make_current()

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_btn_1_pressed():
	select_car(0)
	pass # Replace with function body.

func _on_btn_2_pressed():
	select_car(1)
	pass # Replace with function body.

func _on_btn_3_pressed():
	select_car(2)

func _on_btn_focus_entered(index):
	spawn_car(index)



