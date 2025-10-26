extends Inconvenience

@export var amplitude: float = 2.0     # pixels
@export var frequency: float = 1.0     # oscillations per second

var ground_start_pos: Vector2

func _on_start():
	ground_start_pos = main.get_node("Ground").global_position
	print("Platform shaking started!")

func _on_update(delta):
	# Simple sinusoidal shake
	var offset := Vector2(sin(elapsed * PI * 2 * frequency) * amplitude, 0)
	main.get_node("Ground").global_position = ground_start_pos + offset

func _on_stop():
	main.get_node("Ground").global_position = ground_start_pos
	print("Platform shaking ended!")

func get_text() -> String:
	return "Shake"
