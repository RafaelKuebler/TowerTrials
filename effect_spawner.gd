extends Node2D

@export var powerup_scene: PackedScene

@export var spawn_interval: float = 3.0
@export var spawn_jitter: float = 1.0
@export var spawn_margin: int = 32
@export var max_powerups: int = 5

var timer: Timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	#_start_timer()

func _start_timer():
	var next_wait = clamp(spawn_interval + randf_range(-spawn_jitter, spawn_jitter), 0.1, 999)
	timer.wait_time = next_wait
	timer.timeout.connect(_on_spawn_timeout, CONNECT_ONE_SHOT)
	timer.start()

func _on_spawn_timeout():
	var existing_powerups = get_tree().get_nodes_in_group("powerups")
	if existing_powerups.size() < max_powerups:
		_spawn_powerup()
	_start_timer()

func _spawn_powerup():
	var powerup = powerup_scene.instantiate()
	var viewport_rect = get_viewport_rect()
	var width = viewport_rect.size.x
	var height = viewport_rect.size.y

	var x = randf_range(spawn_margin, width - spawn_margin)
	var y = randf_range(spawn_margin, height - spawn_margin)
	powerup.global_position = Vector2(x, y)

	get_parent().add_child(powerup)
