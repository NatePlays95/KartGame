class_name CarCheckpointTracker
extends Node

##
##
## Put this node inside a SimpleRaycastCar



@export var next_checkpoint : Area3D



@onready var car : SimpleRaycastCar = get_parent()

# tracks distance from the next checkpoint.
var distance : float = 1000



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print_debug("a")
	if not next_checkpoint: return
	
	distance = distance_to_checkpoint(car.global_position, next_checkpoint)
	print_debug(distance)


func distance_to_checkpoint(position:Vector3, checkpoint:Area3D):
	var n := -next_checkpoint.global_transform.basis.z
	var c := next_checkpoint.global_position
	var p := position
	#var point_in_plane = n*d
	var dist = n.dot(p-c)
	return dist
