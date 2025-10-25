extends Node2D

@export var text: String = "YES!"
@export var duration: float = 0.9
@export var start_scale: float = 0.3
@export var end_scale: float = 12.0
@export var fade_start: float = 0.3

@onready var label: Label = $Label

func _ready():
	label.text = text
	label.scale = Vector2(start_scale, start_scale)
	label.modulate.a = 1.0
	label.pivot_offset = label.size / 2

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(label, "scale", Vector2(end_scale, end_scale), duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_interval(duration * fade_start)
	tween.tween_property(label, "modulate:a", 0.0, duration * (1.0 - fade_start))\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
	tween.finished.connect(queue_free)
