extends Inconvenience

@export var rotation_speed: float = 720.0   # degrees per second
@export var min_interval: float = 1.0
@export var max_interval: float = 2.0

var target_direction: float = 1.0
var timer: float = 0.0
var interval: float = 1.5

func _on_start():
	target_direction = 1.0 if randf() < 0.5 else -1.0
	interval = randf_range(min_interval, max_interval)
	timer = 0.0
	print("Random rotation effect started!")

func _on_update(delta):
	if main.current_block:
		# Set angular velocity (degrees per second → radians per second)
		main.current_block.angular_velocity = deg_to_rad(target_direction * rotation_speed)

		timer += delta
		if timer >= interval:
			# Flip rotation direction randomly
			target_direction = 1.0 if randf() < 0.5 else -1.0
			interval = randf_range(min_interval, max_interval)
			timer = 0.0

func _on_stop():
	if main.current_block and main.current_block is RigidBody2D:
		main.current_block.angular_velocity = 0.0
	print("Random rotation effect ended!")
