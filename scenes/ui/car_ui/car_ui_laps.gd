extends Control


var race_progress = preload("res://systems/checkpoints/RaceProgressSingleton.res")

@onready var lbl_current_lap = %lbl_current_lap
@onready var lbl_debug_checkpoints = %lbl_debug_checkpoints




func set_current_lap(current_lap, max_laps):
	var str = "LAP %d / %d" % [clamp(current_lap, 0, max_laps), max_laps]
	lbl_current_lap.text = str


func set_debug_cps(last_cp_index:int, key_cps:Array):
	var max_cp_index = race_progress.get_highest_checkpoint_index()
	var str = "CHECKPOINT %03d/%03d" % [last_cp_index, max_cp_index]
	str += "\nkeys:" + str(key_cps)
	lbl_debug_checkpoints.text = str

