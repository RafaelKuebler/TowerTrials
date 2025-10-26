extends Node

@export var available_effects: Array[Script] = []
@export var trigger_interval: float = 10.0
@export var text_scene: PackedScene

@export var spawn_interval: float = 10.0

var spawn_timer: Timer
var _timer: Timer
var _active_effects: Array[Inconvenience] = []

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	_start_timer()
	
	_timer = Timer.new()
	_timer.wait_time = trigger_interval
	_timer.autostart = true
	_timer.timeout.connect(_trigger_random_effect)
	add_child(_timer)

func _process(delta: float) -> void:
	for e in _active_effects:
		if e.active:
			e.update_effect(delta)
		else:
			e.clean()
			remove_child(e)
			_active_effects.erase(e)
			e.queue_free()

func _trigger_random_effect():
	var inconvenience = available_effects.pick_random().new()
	add_child(inconvenience)
	_active_effects.append(inconvenience)
	inconvenience.start_effect()
	print("Triggered inconvenience:", inconvenience)
	
	# spawn text
	var text = text_scene.instantiate()
	text.text = inconvenience.get_text()
	text.color = "ff0a06"
	add_child(text)

func _start_timer():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timeout, CONNECT_ONE_SHOT)
	spawn_timer.start()

func _on_spawn_timeout():
	_start_timer()
