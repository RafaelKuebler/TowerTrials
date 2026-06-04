extends Area2D

@export var victory_scene_path: PackedScene
@export var required_stay_time: float = 5.0
@export var counter: Label

@onready var victory_player = $"../SoundManager/VictoryPlayer"

var tracked_block: Node
var timer: Timer
var countdown_timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_stay_timer_timeout)
	counter.visible = false
	
	countdown_timer = Timer.new()
	countdown_timer.wait_time = 1.0
	countdown_timer.one_shot = false
	add_child(countdown_timer)
	countdown_timer.timeout.connect(_on_countdown_tick)

func _on_block_landed(block) -> void:
	# for now, if still tracking a block, ignore future blocks
	if tracked_block: return
	
	# check if the block is within the zone
	if block not in get_overlapping_bodies():
		return

	# if yes, start tracking
	print("Block is in victory zone! Tracking...")
	tracked_block = block
	timer.start(required_stay_time)

	timer.start()
	countdown_timer.start()
	counter.visible = true
	counter.text = str(int(required_stay_time))
	await get_tree().create_timer(0.5).timeout

func _physics_process(_delta):
	if tracked_block and tracked_block not in get_overlapping_bodies():
		timer.stop()
		countdown_timer.stop()
		tracked_block = null
		counter.visible = false

func _on_stay_timer_timeout() -> void:
	if tracked_block and tracked_block in get_overlapping_bodies():
		print("Block stayed inside for 5 seconds — victory!")
		_go_to_victory_scene()
	else:
		print("Block was not inside after 5 seconds.")
		counter.visible = false

func _go_to_victory_scene() -> void:
	get_tree().change_scene_to_packed(victory_scene_path)
	counter.visible = false

func _on_countdown_tick():
	var remaining = int(ceil(timer.time_left))
	counter.text = str(remaining)
	if remaining <= 0:
		countdown_timer.stop()
