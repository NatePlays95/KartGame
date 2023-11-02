extends Node


var pause_scene_packed = preload("res://scenes/pause/pause_screen.tscn")
var pause_screen : Control = null







func pause():
	get_tree().paused = true
	
	pause_screen = pause_scene_packed.instantiate()
	get_tree().root.add_child(pause_screen)

func unpause():
	if pause_screen:
		pause_screen.queue_free()
	
	get_tree().paused = false
