extends Area2D

@onready var dust_particles = $DustParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.	dd

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# When player approaches door, set this door as breakable by the player
func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.set_breakable(self)
		
# Break this door
func break_door(player):
	dust_particles.emitting = true
	$StaticBody2D.set_collision_layer_value(1, false)
	$Sprite2D.visible = false	
	player.clear_breakable(self)

# Frees the dust particles when the animation completes
func _on_dust_particles_finished() -> void:
	queue_free()

# Unlinks this door from player when they leave the break zone
func _on_body_exited(body: Node2D) -> void:
	if(body.is_in_group("Player")):	
		body.clear_breakable(self)
