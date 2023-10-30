class_name CarCheckpointTracker
extends Node

##
##
## Put this node inside a SimpleRaycastCar


signal car_completed_lap(car:SimpleRaycastCar, new_lap:int)



# singleton, accessible by race and checkpoint trackers.
var race_progress = preload("res://systems/checkpoints/RaceProgressSingleton.res")

@export var ui_packed_scene : PackedScene = preload("res://scenes/ui/car_ui/car_ui_laps.tscn")
var ui_scene : Control = null

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

var current_lap : int = 1



func _ready():
	car = get_parent()
	car.area_entered.connect(_on_car_area_entered)
	car_completed_lap.connect(RaceManager._on_car_completed_lap)
	
	if ui_packed_scene:
		ui_scene = ui_packed_scene.instantiate()
		add_child(ui_scene)



func _process(delta):
	if ui_scene:
		ui_scene.set_current_lap(current_lap, 2)
		ui_scene.set_debug_cps(last_cp_index,key_cp_crossed)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print_debug("a")
	if not next_checkpoint:
		next_checkpoint = race_progress.get_checkpoint(0)
	
	distance = distance_to_checkpoint(car.global_position, next_checkpoint)
	#print_debug(distance)


func _try_complete_lap():
	#last_cp_index = 0
	#next_checkpoint = race_progress.get_checkpoint(1)
	
	var key_cps = race_progress.track_checkpoints_node.key_checkpoints
	if key_cps.size() > key_cp_crossed.size():
		key_cp_crossed = [] 
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
	
	key_cp_crossed = []


func _complete_lap():
	var new_lap := current_lap + 1
	car_completed_lap.emit(car, new_lap)
	current_lap  = new_lap


func distance_to_checkpoint(position:Vector3, checkpoint:Area3D):
	var n := -next_checkpoint.global_transform.basis.z
	var c := next_checkpoint.global_position
	var p := position
	#var point_in_plane = n*d
	var dist = n.dot(p-c)
	return dist


func has_valid_key_cps(passing_cp:int=0) -> bool:
	var retval := false
	var key_cps = race_progress.track_checkpoints_node.key_checkpoints
	
	for i in range(key_cps.size()): 
		#passing checkpoint comes before the next key checkpoint
		if key_cps[i] >= passing_cp:
			retval = true
			break
		
		#does car have required checkpoints up to this point, in order
		if key_cp_crossed.size() < i+1:
			return false
		
		if key_cp_crossed[i] != key_cps[i]: 
			return false
	
	return retval


func _on_car_area_entered(body: Node):
	if not body is Checkpoint: return
	var cp : Checkpoint = body
	
	if cp.type == Checkpoint.TYPE.START_FINISH:
		last_cp_index = cp.index
		next_checkpoint = race_progress.get_checkpoint(last_cp_index+1)
		_try_complete_lap()
	
	# advance checkpoints
	if cp.index <= last_cp_index: return # no progress was made.
	if last_cp_index == 0 and cp.index > 1: return
	if not has_valid_key_cps(cp.index): return
	
	last_cp_index = cp.index
	next_checkpoint = race_progress.get_checkpoint(last_cp_index+1)
	
	if cp.type == Checkpoint.TYPE.KEY:
		if not key_cp_crossed.has(cp.index):
			key_cp_crossed.push_back(cp.index)
	


