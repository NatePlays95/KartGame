@tool

extends Node3D

# singleton, accessible by race and checkpoint trackers.
var race_progress = preload("res://systems/checkpoints/RaceProgressSingleton.res")


## button to refresh key checkpoints
@export var refresh : bool = false :
	get:
		return refresh
	set(value):
		refresh = false
		_refresh()

## Use this node to store the "key checkpoints" for this track.
@export var key_checkpoints : Array[int] = []
@export var highest_index : int = 0



func _ready():
	if not Engine.is_editor_hint():
		race_progress.track_checkpoints = self



func _refresh():
	key_checkpoints = []
	highest_index = 0
	
	for child in get_children():
		if not child is Checkpoint: continue
		var cp : Checkpoint = child
		
		highest_index = max(highest_index, cp.index)
		
		if cp.type == Checkpoint.TYPE.KEY:
			key_checkpoints.push_back(cp.index)
	
	key_checkpoints.sort()
	#refresh = false


func get_checkpoint(index:int) -> Checkpoint:
	var ret : Checkpoint = null
	
	if index >= highest_index:
		index = 0
	
	for child in get_children():
		if not child is Checkpoint: continue
		var cp : Checkpoint = child
		
		if cp.index == index: 
			ret = cp
			break
	return ret
