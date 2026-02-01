extends Area2D

@onready var dust_particles = $DustParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.	dd

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body):
	var player = get_node("../../Player")
	if body.is_in_group("Player") and player.ram_duration > 0:
		#TODO fix playering not being able to break door if they activate ability inside the BreakBox
		dust_particles.emitting = true
		$StaticBody2D.set_collision_layer_value(1, false)
		$Sprite2D.visible = false

func _on_dust_particles_finished() -> void:
	queue_free()
