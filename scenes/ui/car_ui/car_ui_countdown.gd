extends Control

@onready var car : SimpleRaycastCar = get_parent()

func _ready():
	RaceManager.begin_countdown.connect(_on_begin_countdown)
	RaceManager.car_completed_lap.connect(_on_car_completed_lap)





func _on_begin_countdown():
	%AnimationPlayer.play("countdown")

func _on_car_completed_lap(car_in:SimpleRaycastCar, new_lap:int, max_laps:int):
	if car != car_in: return
	
	if new_lap > max_laps:
		%AnimationPlayer.play("finish")
	else: #new lap popup
		pass
