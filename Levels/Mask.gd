extends Area2D

@onready var mask_sprite = $AnimatedSprite2D

var initial_position := Vector2.ZERO

func _ready():
	initial_position = position
	if self.is_in_group("ChikenMask"):
		mask_sprite.play("ChickenHover")
	elif self.is_in_group("RabbitMask"):
		mask_sprite.play("RabbitHover")
	elif self.is_in_group("RhinoMask"):
		mask_sprite.play("RhinoHover")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var player = get_node("../../Player")
		if self.is_in_group("ChickenMask"):
			player.ability = 1
		elif self.is_in_group("RabbitMask"):
			player.ability = 2
		elif self.is_in_group("RhinoMask"):
			player.ability = 3
			
		queue_free()
