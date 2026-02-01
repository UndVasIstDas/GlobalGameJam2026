extends Node2D

var started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Start") and not started: load_world(null)
		
		
func load_world(world):
	if(world):
		remove_child(world)
		world.queue_free()
	get_node("MainMenu").visible = false
	add_child(load("res://Levels/world.tscn").instantiate())
	started = true
