class_name Main
extends Node2D

@export var block_scenes: Array[PackedScene] = []
@export var max_spawn_interval := 10.0  # max seconds between spawns
@export var min_spawn_cooldown := 2.0  # minimum time between spawns

@onready var spawn_point = $SpawnPoint
@onready var blocks_container = $Blocks
@onready var music_player = $SoundManager/MusicPlayer
@onready var touchdown_player = $SoundManager/TouchdownPlayer
@onready var victory_zone = $VictoryZone

var current_block: RigidBody2D = null
var last_spawn_time := 0.0

var FALL_SPEED := 50.0
var MOVE_SPEED := 80.0
var TURN_SPEED := 5.0
var X_LIMIT := 600.0

func _ready():
	spawn_new_block()

func spawn_new_block():
	var now := Time.get_ticks_msec() / 1000.0
	# Prevent spawning too soon after the previous one
	if now - last_spawn_time < min_spawn_cooldown:
		return

	var scene = block_scenes.pick_random()
	current_block = scene.instantiate()
	current_block.gravity_scale = 0
	current_block.z_index = 10
	current_block.modulate.a = 1
	current_block.rotation = randf_range(0.0, TAU)
	blocks_container.add_child(current_block)
	current_block.global_position = spawn_point.global_position
	current_block.connect("landed", Callable(self, "_on_block_landed"))
	current_block.connect("landed", Callable(victory_zone, "_on_block_landed"))

	last_spawn_time = now

func _physics_process(_delta):
	var now := Time.get_ticks_msec() / 1000.0

	# --- Failsafe spawn timer ---
	# If too long without any current block, spawn one (respecting cooldown)
	if current_block == null and now - last_spawn_time > max_spawn_interval:
		print("⚠️ Forcing new block spawn (failsafe)")
		spawn_new_block()

	# --- Control logic ---
	if current_block and current_block.get_meta("controllable"):
		var reversed = get_meta("controls_reversed") if has_meta("controls_reversed") else false
		var vel := current_block.linear_velocity

		# Rotation
		if reversed:
			if Input.is_action_pressed("move_left"):
				current_block.angular_velocity = -TURN_SPEED
			elif Input.is_action_pressed("move_right"):
				current_block.angular_velocity = TURN_SPEED
			else:
				current_block.angular_velocity = 0.0
		else:
			if Input.is_action_pressed("rotate_left"):
				current_block.angular_velocity = -TURN_SPEED
			elif Input.is_action_pressed("rotate_right"):
				current_block.angular_velocity = TURN_SPEED
			else:
				current_block.angular_velocity = 0.0
		
		# Horizontal Movement
		var move_dir := 0.0
		if reversed:
			if Input.is_action_pressed("rotate_left"):
				move_dir -= 1.0
			if Input.is_action_pressed("rotate_right"):
				move_dir += 1.0
		else:
			if Input.is_action_pressed("move_left"):
				move_dir -= 1.0
			if Input.is_action_pressed("move_right"):
				move_dir += 1.0
		
		vel.x = move_dir * MOVE_SPEED
		vel.y = FALL_SPEED
		current_block.linear_velocity = vel

func _on_block_landed(_block):
	if current_block:
		current_block.gravity_scale = 1
		touchdown_player.play()
		current_block.set_meta("controllable", false)
		current_block.angular_velocity = 0.0
		current_block = null
		await get_tree().create_timer(0.5).timeout
		call_deferred("spawn_new_block")
