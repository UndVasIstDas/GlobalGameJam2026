extends Node2D

var num_enter_pressed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Start") and num_enter_pressed <= 1: load_world(null)
		
		
func load_world(world):
	num_enter_pressed += 1
	get_node("MainMenu/SplashArt").visible = false
	if num_enter_pressed == 1:
		get_node("MainMenu/Instructions").visible = true
		return
	elif(world):
		remove_child(world)
		world.queue_free()
	get_node("MainMenu/Instructions").visible = false
	add_child(load("res://Levels/world.tscn").instantiate())
