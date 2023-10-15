class_name ChaseCamera
extends Camera3D


@export var cam_distance : float = 8
@export var cam_height : float = 3
@export var speed : float = 10

@export var car : SimpleRaycastCar
#onready var car = get_node_or_null(car_path)

@onready var target_pos : Vector3 = car.global_position

func _ready():
	pass


func _find_position(up:Vector3):
	var pos = car.global_position
	var forward = -car.global_transform.basis.z
	
	pos -= forward*cam_distance
	pos += up*cam_height
	
	return pos


func _physics_process(dt):
	
	
	if car.global_transform.basis.y.dot(Vector3.UP) < 0.1:
		var local_up = lerp(self.global_transform.basis.y, car.global_transform.basis.y, dt)
		global_transform.origin = lerp(global_transform.origin, _find_position(local_up), dt*speed)
		look_at(car.global_transform.origin, local_up)
	else:
		var local_up = lerp(self.global_transform.basis.y, Vector3.UP, 10*dt)
		global_transform.origin = lerp(global_transform.origin, _find_position(local_up), dt*speed)
		look_at(car.global_transform.origin, local_up)

