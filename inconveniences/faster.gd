extends Inconvenience

@export var speed_multiplier: float = 1.5

var timer: float = 0.0

func _on_start():
	main.FALL_SPEED *= speed_multiplier
	timer = 0.0
	print("Fall speed increased!")

func _on_update(delta):
	timer += delta
	if timer >= duration:
		main.FALL_SPEED /= speed_multiplier
		active = false

func _on_stop():
	main.FALL_SPEED /= speed_multiplier
	print("Fall speed inconvenience ended!")

func get_text() -> String:
	return "Faster"
