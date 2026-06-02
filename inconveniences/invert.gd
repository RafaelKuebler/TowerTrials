extends Inconvenience

func _on_start():
	main.set_meta("controls_reversed", true)
	print("Player controls reversed!")

func _on_stop():
	main.set_meta("controls_reversed", false)
	print("Player controls returned to normal.")

func get_text() -> String:
	return "Invert"
