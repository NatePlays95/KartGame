extends Node3D

@onready var anim_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	RaceManager.do_intro_camera_flydown.connect(_on_intro_camera_flydown)
	RaceManager.ready_cameras = true



func _on_intro_camera_flydown() -> void:
	print_debug("i exist")
	anim_player.play("intro1")
	anim_player.queue("intro2")
	anim_player.queue("intro3")
	anim_player.queue("RESET")
	await anim_player.animation_finished
	await anim_player.animation_finished
	await anim_player.animation_finished
	#anim_player.play("RESET")
	return


