extends Node3D

enum MODE { OLD }
@export var camera_mode : MODE = MODE.OLD

@onready var car : SimpleRaycastCar = get_parent()
@onready var camera_3d : Camera3D = %Camera3D
@onready var look_at : Vector3 = car.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match camera_mode:
		MODE.OLD:
			_process_old(delta)



func _process_old(delta):
	var speed = car.get_speed()
	
	global_position = global_position.lerp(car.global_position, delta*100.0)
	#speed shake
	if speed > 5:
		global_position += speed * 0.05 * delta * Vector3(randf_range(-1.0,1.0),randf_range(-1.0,1.0),randf_range(-1.0,1.0))
	
	if speed < 0:
		transform = transform.interpolate_with(car.transform, delta*10.0)
	else:
		transform = transform.interpolate_with(car.transform, delta*10.0)
	
	var ground_velocity = car.linear_velocity - car.linear_velocity.project(car.global_transform.basis.y)
	ground_velocity *= 0
	look_at = look_at.lerp(car.global_position + ground_velocity + Vector3.UP*1, delta * 100.0)
	camera_3d.look_at(look_at)
	
	camera_3d.fov = lerp(camera_3d.fov, 70 + abs(speed)*1.2, delta*10.0)
	
	#camera_3d.h_offset = 0
	var drift_offset_factor = 0.01
	if car.is_drifting and car.is_grounded:
		camera_3d.h_offset = lerp(camera_3d.h_offset, speed * car.drift_dir * drift_offset_factor, delta * 1.0)
	else:
		camera_3d.h_offset = lerp(camera_3d.h_offset, 0.0, delta * 5.0)
