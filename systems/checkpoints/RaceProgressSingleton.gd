class_name RaceProgressSingleton
extends Resource


var track_checkpoints = null


func _reset():
	track_checkpoints = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_checkpoint(index:int) -> Checkpoint:
	return track_checkpoints.get_checkpoint(index)
