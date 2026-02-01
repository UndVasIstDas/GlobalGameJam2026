extends AnimatedSprite2D

@onready var cooldown_container = $CooldownContainer
@onready var cooldown_timer = $CooldownTimer

# Hide cooldown mask on ready
func _ready() -> void:
	cooldown_container.hide()

func _process(_delta: float) -> void:
	pass

# Set timer duration and show cooldown mask
func start_cooldown(duration):
	cooldown_timer.wait_time = duration
	cooldown_timer.start()
	cooldown_container.show()

# Hide cooldown mask when timer completes
func _on_cooldown_timer_timeout() -> void:
	cooldown_container.hide()
