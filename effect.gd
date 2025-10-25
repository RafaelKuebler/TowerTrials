extends Area2D

@export var text_scene: PackedScene
@export var circle_radius: float = 5.0
@export var circle_speed: float = 2.0

@onready var sound_player: AudioStreamPlayer = $AudioStreamPlayer

var possible_types = [
	"/2",
	"W+",
]

var angle: float = 0.0
var start_position: Vector2
var type: String

func _ready():
	type = possible_types.pick_random()
	$Label.text = type
	start_position = global_position
	body_entered.connect(_on_body_entered)

func _process(delta):
	angle += circle_speed * delta
	global_position.x = start_position.x + cos(angle) * circle_radius
	global_position.y = start_position.y + sin(angle) * circle_radius

func _on_body_entered(body):
	if body is RigidBody2D:
		print("Power-up collected by: ", body.name)
		var text = text_scene.instantiate()
		#text.global_position = global_position
		text.text = type
		get_tree().current_scene.add_child(text)
		sound_player.play()
		
		if type == "/2":
			pass
		elif type == "W+":
			pass

		queue_free()
