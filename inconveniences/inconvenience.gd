class_name Inconvenience
extends Node

@onready var ui_indicator: Control = get_tree().get_current_scene().get_node("Inconveniences")
@onready var main: Main = get_tree().get_current_scene()

var icons = {
	"Faster": preload("res://graphics/tile_0012.png"),
	"Shake": preload("res://graphics/tile_0041.png"),
	"Destruction": preload("res://graphics/tile_0055.png"),
	"Invert": preload("res://graphics/tile_0123.png")
}
var font = preload("res://ARCADECLASSIC.TTF")

var duration: float = 8.0
var active: bool = false
var elapsed: float = 0.0

var ui_icon: TextureRect
var ui_timer: Label

# Called when the effect starts
func start_effect():
	active = true
	elapsed = 0.0
	_on_start()
	
	ui_icon = TextureRect.new()
	ui_icon.texture = icons[get_text()]
	ui_icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	ui_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	ui_indicator.add_child(ui_icon)

	ui_timer = Label.new()
	ui_timer.add_theme_font_override("font", font)
	ui_timer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ui_timer.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	ui_timer.text = str(int(duration))
	ui_indicator.add_child(ui_timer)

# Called every frame while the effect is active
func update_effect(delta):
	if not active:
		return
	elapsed += delta
	
	ui_timer.text = str(int(ceil(duration-elapsed)))
	
	_on_update(delta)
	if elapsed >= duration:
		stop_effect()

# Called when the effect ends
func stop_effect():
	if not active:
		return
	_on_stop()
	active = false

func clean():
	ui_icon.queue_free()
	ui_timer.queue_free()

# Override these in subclasses
func _on_start(): pass
func _on_update(delta): pass
func _on_stop(): pass
func get_text() -> String: return ""
