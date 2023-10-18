class_name CarCheckpointTracker
extends Node

##
##
## Put this node inside a SimpleRaycastCar

# singleton, accessible by race and checkpoint trackers.
var race_progress = preload("res://systems/checkpoints/RaceProgressSingleton.res")



#@export var next_checkpoint : Area3D

@onready var car : SimpleRaycastCar = get_parent()


var last_cp_index : int = 0
var next_checkpoint : Checkpoint = null

# all the indexes of key checkpoints crossed so far.
# cross all key checkpoints first before a lap 
# can be registered at a finish line.
var key_cp_crossed : Array[int] = []

# tracks distance from the next checkpoint.
var distance : float = 1000

var current_lap = 1



func _ready():
	car = get_parent()
	car.area_entered.connect(_on_car_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print_debug("a")
	if not next_checkpoint:
		next_checkpoint = race_progress.get_checkpoint(0)
	
	distance = distance_to_checkpoint(car.global_position, next_checkpoint)
	#print_debug(distance)


func _try_complete_lap():
	var key_cps = race_progress.track_checkpoints.key_checkpoints
	if key_cps.size() > key_cp_crossed.size(): 
		return # if has crossed less checkpoints than the total
	
	var is_perfect_match = true
	key_cp_crossed.sort()
	# side effect, if there are no key checkpoints
	# it automatically succeeds.
	
	for i in range(key_cps.size()):
		if key_cp_crossed[i] != key_cps[i]: 
			is_perfect_match = false
			break
	
	if is_perfect_match:
		_complete_lap()

func _complete_lap():
	current_lap += 1
	key_cp_crossed = []


func distance_to_checkpoint(position:Vector3, checkpoint:Area3D):
	var n := -next_checkpoint.global_transform.basis.z
	var c := next_checkpoint.global_position
	var p := position
	#var point_in_plane = n*d
	var dist = n.dot(p-c)
	return dist


func _on_car_area_entered(body: Node):
	if not body is Checkpoint: return
	var cp : Checkpoint = body
	
	# advance checkpoints
	if cp.index <= last_cp_index: return # no progress was made.
	
	last_cp_index = cp.index
	next_checkpoint = race_progress.get_checkpoint(last_cp_index+1)
	
	if cp.type == Checkpoint.TYPE.KEY:
		if not key_cp_crossed.has(cp.index):
			key_cp_crossed.push_back(cp.index)
	
	if cp.type == Checkpoint.TYPE.START_FINISH:
		_try_complete_lap()

