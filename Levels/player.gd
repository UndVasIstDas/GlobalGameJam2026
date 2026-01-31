extends CharacterBody2D

# Player Physics Properties
@export_category("Player Physics Properties")
@export var SPEED = 300.0
@export var JUMP_FORCE = 500.0
@export var GRAVITY = 20

# Player Abilities
@export_category("Player Abilities")
@export var ability = 0 # ["None", "Double Jump", "Speed", "Ram"]

@export var max_speed_duration = 2
var speed_duration = 0
@export var speed_multiplier = 1.5

@export var max_ram_duration = 2
var ram_duration = 0

func _process(_delta):
	handle_abilities()
	movement(_delta)

func handle_abilities():
	if Input.is_action_just_pressed("Power"):
		if ability == 1 and not is_on_floor():
			velocity.y = -JUMP_FORCE
			ability = 0
		elif ability == 2:
			speed_duration = max_speed_duration
			ability = 0
		elif ability == 3:
			ram_duration = max_ram_duration
			ability = 0

func movement(_delta):
	# Add the gravity.
	if !is_on_floor():
		velocity.y += GRAVITY
	
	jump()

	# Get the input direction and handle the movement/deceleration.
	
	var direction := Input.get_axis("Left", "Right")
	
	var modified_speed = SPEED
	if speed_duration > 0:
		modified_speed = SPEED * speed_multiplier
		speed_duration -= _delta
	else:
		speed_duration = 0
	
	if direction:
		velocity.x = direction * modified_speed
	else:
		velocity.x = move_toward(velocity.x, 0, modified_speed)

	move_and_slide()
	
func jump():
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = -JUMP_FORCE	
