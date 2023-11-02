extends Control



func _ready():
	%btn_resume.grab_focus()


func _input(event):
	if Input.is_action_just_pressed("pause"):
		await get_tree().create_timer(0.1, true).timeout
		Pause.unpause()


func _on_btn_resume_pressed():
	Pause.unpause()


func _on_btn_exit_pressed():
	Pause.unpause()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
