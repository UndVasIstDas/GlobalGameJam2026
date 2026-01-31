extends Area2D

const VIEWPORT_SPEED = 0.001 			# Scalar for viewport movement function

var module_list = ["module_01.tscn"] 	# List of module scenes
var module_count = 0 	# Number of modules loaded
var module_pos = 0 		# x-offset for the next module

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Instantiate module scenes

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move camera proportional to time (in seconds)
	position += Vector2(VIEWPORT_SPEED*pow(Time.get_ticks_msec(),2)/1000000, 0)
	
	# Load scenes
	# if(module_count < 3):
	#	add_child(get_node(module_list[0]))
	
	# TODO: Unload scenes
