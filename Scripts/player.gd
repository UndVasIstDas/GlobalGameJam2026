extends CharacterBody2D

# Player Physics Properties
@export_category("Player Physics Properties")
@export var SPEED_BASE = 300.0
@export var JUMP_FORCE = 600.0
@export var GRAVITY = 25
var speed = SPEED_BASE

# Player Abilities
@export_category("Player Abilities")

@export var max_dash_duration = 0.25
var dash_duration = 0
@export var speed_multiplier = 1.5

@onready var player_sprite = $AnimatedSprite2D

var breakable_object = null

func _process(delta):
	handle_abilities()
	movement(delta)
	player_animations()
	flip_player()

func handle_abilities():
	if Input.is_action_just_pressed("Power1") and not is_on_floor():
		velocity.y = -JUMP_FORCE
	elif Input.is_action_just_pressed("Power2"):
		dash_duration = max_dash_duration
	elif Input.is_action_just_pressed("Power3") and not breakable_object == null:
		breakable_object.break_door(self)

func movement(delta):
	# Add the gravity.
	if !is_on_floor():
		velocity.y += GRAVITY
	
	jump()

	# Get the input direction and handle the movement/deceleration.
	
	var direction := Input.get_axis("Left", "Right")
	
	if dash_duration > 0:
		dash_duration -= delta
		velocity.x = speed*1.5
		velocity.y *= 0.3
	else:
		dash_duration = 0
		if direction < 0:
			velocity.x = direction * SPEED_BASE
		elif direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	

	move_and_slide()
	
func jump():
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = -JUMP_FORCE	

# Handle player animations
func player_animations():
	if is_on_floor():
		if abs(velocity.x) > 0:
			player_sprite.play("Run")
		else:
			pass
			#player_sprite.play("Idle")
	else:
		pass
		#player_sprite.play("Jump")
		
# Flip player sprite based on X velocity
func flip_player():
	if velocity.x > 0: 
		player_sprite.flip_h = true
	elif velocity.x < 0:
		player_sprite.flip_h = false
		
# Mark door as breakable
func set_breakable(body):
	breakable_object = body
	
func clear_breakable(body):
	if breakable_object == body:
		breakable_object = null
