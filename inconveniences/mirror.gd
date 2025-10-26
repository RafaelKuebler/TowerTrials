extends Inconvenience

var timer: float = 0.0

func _on_start():
	if main.current_block:
		main.current_block.set_meta("controls_reversed", true)
	timer = 0.0
	print("Player controls reversed!")

func _on_update(delta):
	timer += delta
	if timer >= duration:
		active = false  # deactivate

func _on_stop():
	if main.current_block:
		main.current_block.set_meta("controls_reversed", false)
	print("Player controls returned to normal.")
