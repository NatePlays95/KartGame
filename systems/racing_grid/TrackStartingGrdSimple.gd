extends Node3D


# singleton, accessible by race and checkpoint trackers.
var race_progress = preload("res://systems/checkpoints/RaceProgressSingleton.res")




func _ready():
	if not Engine.is_editor_hint():
		if not RaceManager.current_race: return
		
		spawn_player_cars() # TODO: spawn all cars
		RaceManager.ready_starting_grid = true



func spawn_player_cars() -> void:
	var markers = get_children()
	var player_cars_list = RaceManager.current_race.player_cars.duplicate()
	var position_count = min(player_cars_list.size(), markers.size())
	
	for current_position in range(position_count):
		var car_instance : SimpleRaycastCar = player_cars_list[current_position].instantiate()
		car_instance.global_transform = markers[current_position].global_transform
		
		# test race types
		# parts to add to player cars, maybe not here, but somewhere?
		var time_tracker = CarTimeTracker.new()
		var check_tracker = CarCheckpointTracker.new()
		car_instance.add_child(time_tracker)
		car_instance.add_child(check_tracker)
		
		# change to add to viewports
		get_tree().current_scene.add_child.call_deferred(car_instance)



func _process(delta):
	pass
