extends RigidBody2D

signal landed(block)

@export var fall_speed := 50.0  # pixels per second

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	set_meta("controllable", true)
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(_body):
	call_deferred("set_contact_monitor", false)
	set_meta("controllable", false)
	emit_signal("landed", self)
