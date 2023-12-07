extends Control


@onready var lbl_current_time : Label = %lbl_current_time
@onready var lbl_splits : Label = %lbl_splits

# Called when the node enters the scene tree for the first time.
func _ready():
	lbl_splits.text = ""
	lbl_splits.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_current_time(time_formatted:String):
	lbl_current_time.text = "TIME: " + time_formatted

func set_splits(splits_formatted:Array):
	print_debug(splits_formatted)
	var str = ""
	for i in range(1, splits_formatted.size()+1):
		str += ("LAP %d: " % i) + splits_formatted[i-1] + "\n"
	lbl_splits.text = str
	lbl_splits.visible = true
