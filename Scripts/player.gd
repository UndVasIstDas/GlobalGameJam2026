extends CharacterBody2D

# Player Physics Properties
@export_category("Player Physics Properties")
@export var SPEED_BASE = 300.0
@export var JUMP_FORCE = 600
@export var GRAVITY = 25
var speed = SPEED_BASE

# Player Abilities
@export_category("Player Abilities")
@export var max_dash_duration = 0.25
var dash_duration = 0
@export var speed_multiplier = 1.5

# Ability cooldowns
@export var BASE_COOLDOWN = 0.5
var max_cooldown = BASE_COOLDOWN
var dash_cooldown = 0
var jump_cooldown = 0
var ram_cooldown = 0

@onready var player_sprite = $AnimatedSprite2D
var state = "Default"

var breakable_object = null

var can_jump = true

# Main process
func _physics_process(delta):
	if get_parent().is_game_active:
		handle_cooldowns(delta)
		handle_abilities()
		movement(delta)
		player_animations()
		flip_player()

# Parse ability input
func handle_abilities():
	if Input.is_action_just_pressed("Power1") and not is_on_floor() and jump_cooldown <= 0:
		velocity.y = -JUMP_FORCE
		$JumpSFX.play()
		jump_cooldown = max_cooldown
		player_sprite.stop()
		state = "Chicken"
		$"../Viewport/Hotbar/Chicken".start_cooldown(max_cooldown)
	elif Input.is_action_just_pressed("Power2") and dash_cooldown <= 0:
		dash_duration = max_dash_duration
		dash_cooldown = max_cooldown
		player_sprite.stop()
		state = "Rabbit"
		$"../Viewport/Hotbar/Rabbit".start_cooldown(max_cooldown)
	elif Input.is_action_just_pressed("Power3") and breakable_object and ram_cooldown <= 0:
		$CrashSFX.play()
		breakable_object.break_door(self)
		ram_cooldown = max_cooldown
		player_sprite.stop()
		state = "Rhino"
		$"../Viewport/Hotbar/Rhino".start_cooldown(max_cooldown)

# Decrease ability cooldown timers
func handle_cooldowns(delta):
	max_cooldown = max(0.1, BASE_COOLDOWN - floor(get_parent().score)/500)
	if jump_cooldown > 0:
		jump_cooldown -= delta
	
	if dash_cooldown > 0:
		dash_cooldown -= delta
	
	if ram_cooldown > 0:
		ram_cooldown -= delta
	
# Move player
func movement(delta):
	# Update coyote timer
	if can_jump == false and is_on_floor():
		can_jump = true
	
	if not is_on_floor() and can_jump and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY
	
	# Jump with coyote time
	if Input.is_action_just_pressed("Jump") and can_jump:
		jump()

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("Left", "Right")
	
	# If the player is dashing, for them to move, else normal movement
	if dash_duration > 0:
		dash_duration -= delta
		velocity.x = speed*1.5
		velocity.y *= 0.3
	else:
		# If the player is going backways, don't add the viewports move speed
		if direction < 0:
			velocity.x = direction * SPEED_BASE
		elif direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

func jump():
	$JumpSFX.play()
	velocity.y = -JUMP_FORCE
	can_jump = false

func _on_coyote_timer_timeout() -> void:
	can_jump = false

# Handle player animations
func player_animations():
	if is_on_floor():
		if abs(velocity.x) > 0:
			player_sprite.play("%sRun"%state)
		else:
			player_sprite.play("%sIdle"%state)
	else:
		player_sprite.play("%sJump"%state)

# Flip player sprite based on X velocity
func flip_player():
	if velocity.x > 0: 
		player_sprite.flip_h = true
	elif velocity.x < 0:
		player_sprite.flip_h = false

# Mark door as breakable
func set_breakable(body):
	breakable_object = body

# Unlinks given door from the player
func clear_breakable(body):
	if breakable_object == body:
		breakable_object = null
