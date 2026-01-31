extends Node2D

const VIEWPORT_SPEED_MOD = 0.01 			# Scalar for viewport movement function
const MODULE_PATH = "res://Levels";
const MODULE_LIST = ["module_0","module_1"] 	# List of module scenes

var module_count = 0 	# Number of modules loaded
var module_pos = 0 		# x-offset for the next module

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Instantiate module scenes
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move camera proportional to time (in seconds)
	var speed = max(VIEWPORT_SPEED_MOD*pow(Time.get_ticks_msec(),2)/1000000, 1)
	get_node("Viewport").position += Vector2(speed, 0) # Update viewport speed
	get_node("Player").SPEED = 300+speed/delta
	
	
	#Load scenes
	if(module_count < 10):
		var new_module = load("%s/%s.tscn"%[MODULE_PATH, MODULE_LIST.pick_random()]).instantiate()
		new_module.position += Vector2(module_pos, 0) # Adjust to proper position
		add_child(new_module)
		# Update offset
		var tilemap = new_module.get_node("TileMapLayer")
		module_pos += tilemap.get_used_rect().size.x*tilemap.tile_set.tile_size.x
		module_count += 1
	
	# TODO: Unload scenes

# Killbox handling
func _on_leftbound_body_entered(body: Node2D) -> void:
	if body.get_class() == "CharacterBody2D":
		print("Player is dead!")
		get_tree().quit()
