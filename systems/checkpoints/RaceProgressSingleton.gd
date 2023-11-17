class_name RaceProgressSingleton
extends Resource


var track_checkpoints_node = null


func _reset():
	track_checkpoints_node = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_checkpoint(index:int) -> Checkpoint:
	if not track_checkpoints_node: return null
	return track_checkpoints_node.get_checkpoint(index)


func get_highest_checkpoint_index() -> int:
	if not track_checkpoints_node: return 0
	return track_checkpoints_node.highest_index
