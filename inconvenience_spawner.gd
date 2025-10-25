extends Node2D

@export var spawn_interval: float = 10.0

var timer: Timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	_start_timer()

func _start_timer():
	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_spawn_timeout, CONNECT_ONE_SHOT)
	timer.start()

func _on_spawn_timeout():
	_start_timer()
