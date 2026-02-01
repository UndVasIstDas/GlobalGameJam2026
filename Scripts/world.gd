extends Node2D

const VIEWPORT_SPEED_MOD = .05 			# Scalar for viewport movement function
const MODULE_PATH = "res://Levels";
const MODULE_LIST = ["module_0", "module_1", "module_2"] 	# List of module scenes
const MODULE_LIMIT = 10

var module_pos_queue = [0] 		# x-offset for the next module
var module_queue = []	# queue tracking the number of modules
var score = 0

signal init_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_module
	for i in range(0,2):
		new_module = load("%s/%s.tscn"%[MODULE_PATH, MODULE_LIST.pick_random()]).instantiate()
		new_module.position += Vector2(module_pos_queue[0], 0) # Adjust to proper position
		add_child(new_module)
		# Update offset
		module_pos_queue.push_front(module_pos_queue[0]+new_module.get_node("end").position.x)
		
		module_queue.push_back(new_module)
	
	emit_signal("init_done")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move camera proportional to time (in seconds)
	var speed = max(VIEWPORT_SPEED_MOD*sqrt(Time.get_ticks_msec()), 2)
	get_node("Viewport").position += Vector2(speed, 0) # Update viewport speed
	get_node("Player").speed = 300+1.1*speed/(delta)
	
	# Update score
	score += floor(100*speed*delta)/100
	get_node("Viewport/Score/Label").text = "Score: %d"%score
	
	#Load scenes
	if(module_queue.size() < MODULE_LIMIT):
		var new_module = load("%s/%s.tscn"%[MODULE_PATH, MODULE_LIST.pick_random()]).instantiate()
		new_module.position += Vector2(module_pos_queue[0], 0) # Adjust to proper position
		add_child(new_module)
		# Update offset
		module_pos_queue.push_front(module_pos_queue[0]+new_module.get_node("end").position.x)
		
		# Reduce size of module queue
		if(module_pos_queue.size() > MODULE_LIMIT/2):
			module_pos_queue.pop_back()
		
		module_queue.push_back(new_module)

	#Unload scenes
	if(module_queue.size() >= MODULE_LIMIT and get_node("Player").global_position.x > module_pos_queue[module_pos_queue.size()-1]):
		module_queue.pop_front().queue_free()
			


# Killbox handling
func _on_bound_body_entered(body: Node2D) -> void:
	if body.get_class() == "CharacterBody2D":
		print("Player is dead! Score was %d"%score)
		get_tree().quit()
