@tool
class_name SimpleWheel
extends ShapeCast3D

const ROAD_MATERIALS := preload("res://systems/car/RoadMaterialGroups.tres")

@export var simple_steering : bool = true

@export var wheel_radius : float = 0.2 :
	get:
		return wheel_radius
	set(new_value):
		new_value = max(0.001, new_value)
		wheel_radius = new_value
		_update_shape()

@export var spring_length : float = 0.3 :
	get:
		return spring_length
	set(new_value):
		new_value = max(0.001, new_value)
		spring_length = new_value
		target_position = Vector3(0,-1,0) * new_value
		_update_children_positions()


@export var spring_stiffness : float = 10
@export var compress_damping : float = 1
@export var rebound_damping : float = 0.7

var car : SimpleRaycastCar
var contact_material : RoadMaterial = null

var deform : float = 0 # 0 to 1
var last_deform : float = 0 # 0 to 1


# Called when the node is instantiated, before it enters the scene tree.
func _init():
	wheel_radius = wheel_radius # update shape
	spring_length = spring_length # update children

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	_update_children_positions()


# to be called from the parent Car node
func _update_physics(dt):
	#var car : SimpleRaycastCar = get_parent()
	_update_suspension(dt)
	_update_movement(dt)
	_update_drag(dt)
	# finish up
	_update_children_positions()


func _update_suspension(dt):
	deform = (1 - get_closest_collision_unsafe_fraction())
	
	if not is_colliding():
		last_deform = 0
		contact_material = null
		return
	
	if deform == 0: #colliding, yet deform is 0
		if _get_collision_result() != []: #bugged collisions
			deform = 1 #continue
		else: # (not is_colliding())
			last_deform = 0
			contact_material = null
			return
	
	#### material ####
	var contact_obj := get_collider(0) #only test the first collision.
	#print_debug(contact_obj)
	var surface_name := ""
	if contact_obj.get_groups().size() > 0:
		surface_name = contact_obj.get_groups()[0] #only test the first group.
	#TODO: test all groups, find the one with most grip
	contact_material = ROAD_MATERIALS.get_material(surface_name)
	#print_debug(contact_material.group_name)
	
	#### springs ####
	var spring_force = spring_stiffness * deform
	
	var delta_deform = (last_deform - deform)
	var up_or_down = sign(delta_deform)
	var damp_force = delta_deform/dt
	if up_or_down == 1:
		damp_force *= rebound_damping
	elif up_or_down == -1:
		damp_force *= compress_damping
	
	var final_force = car.mass * (spring_force - damp_force) # force is length-independent, mass-independent
	var force_pos = global_position - car.global_position
	force_pos -= (1-deform)*transform.basis.y*spring_length
	car.apply_force(global_transform.basis.y * final_force, force_pos)
	
	#### bumpiness ####
	var bumpiness := contact_material.bumpiness
	if bumpiness > 0:
		var terrain_push = car.mass * car.linear_velocity.length()
		terrain_push *= min(0, randf_range(-1,1)) * bumpiness
		car.apply_force(global_transform.basis.y * terrain_push, force_pos)
	
	last_deform = deform


func _update_movement(dt):
	if deform == 0: return
	
	var factor = 1.0 / car.wheels.size()
	var forward = -car.global_transform.basis.z
	if car.is_drifting:
		forward = (forward - car.global_transform.basis.x * car.drift_dir).normalized()
		forward *= car.drift_power_multiplier
	
	var throttle_force = forward * car.engine_throttle * factor
	#print(throttle_force)
	car.apply_central_force(throttle_force)
	
	##braking
	#var braking_drag = 1 * car.input_brakes
	#car.linear_velocity *= 1.0 - dt * braking_drag * factor
	forward = -car.global_transform.basis.z
	var braking_force = -forward * car.braking_force * factor
	car.apply_central_force(braking_force)


func _update_drag(dt):
	var factor = 1.0 / car.wheels.size()
	
	#### standard linear drag ####
	
	if deform == 0 or contact_material == null: #air
		var air_drag = 0
		#car.linear_velocity *= 1.0 - dt * air_drag * factor
		return #no slip drag
	#not air
	var drag = contact_material.drag
	car.linear_velocity *= 1.0 - dt * drag * factor
	
	#### steering drag ####
	var slide_drag = contact_material.slide_drag
	var sideways_velocity = car.linear_velocity.dot(car.global_transform.basis.x)
	if car.is_drifting:
		slide_drag *= 0.6
	var sideways_counterforce = car.mass * sideways_velocity * slide_drag
	car.apply_central_force(-car.global_transform.basis.x  * sideways_counterforce * factor)


func _update_children_positions() -> void:
	for child in self.get_children():
		if not (child is Node3D): continue
		if (child.name.begins_with("@")): continue #debug mesh
		
		var child3d : Node3D = child as Node3D
		child3d.position = get_closest_collision_unsafe_fraction() * target_position

func _update_shape() -> void:
	if not (shape is SphereShape3D):
		shape = SphereShape3D.new()
	
	shape.radius = wheel_radius
	shape.margin = 0.0001
