@tool
class_name Checkpoint
extends Area3D


## Checkpoints that dictate race completion and racer position.
##
## Use the provided Checkpoint.scn instead of making a new Area3D.
##
## Not automated: set CollisionShape3D shape to BoxShape, z = 0.1
## Checkpoint's forward direction is always its -Z.
## Don't move or rotate the internal CollisionShape3D

@onready var col := %col
var dirty := true

@export var width : float = 16 :
	get:
		#if col == null: return 0
		return width
	set(value):
		#if col == null: return
		width = max(0.1, value)
		update_shape(Vector2(value,-1))

@export var height : float = 9 :
	get:
		#if col == null: return 0
		return height
	set(value):
		#if col == null: return
		height = max(0.1, value)
		update_shape(Vector2(-1,value))


func _process(_d):
	if dirty:
		update_shape(Vector2(width, height))


func update_shape(vec:Vector2):
	dirty = true
	if col == null: return

	col.shape = col.shape.duplicate()
	
	if vec.x == -1: vec.x = col.shape.size.x
	if vec.y == -1: vec.y = col.shape.size.y
	
	col.shape.size.x = vec.x
	col.shape.size.y = vec.y
	col.shape.size.z = 0.1
	
	%debug_mesh.size.x = col.shape.size.x
	%debug_mesh.size.y = col.shape.size.y
	%debug_mesh.size.z = 0.1
	dirty = false




