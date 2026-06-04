extends Control

@export_file("*.tscn") var game_scene_path: String
@export var hamster_texture: Array[Texture2D]

@onready var restart_button: Button = $CenterContainer/VBoxContainer/Button

func _ready():
	var hamster: TextureRect = get_node_or_null("CenterContainer/VBoxContainer/TextureRect")
	if hamster:
		hamster.texture = hamster_texture.pick_random()
	restart_button.pressed.connect(_on_restart_button_pressed)

func _on_restart_button_pressed():
	get_tree().change_scene_to_file(game_scene_path)

func _input(event):
	if not event.is_action_pressed("ui_accept"):
		return
	_on_restart_button_pressed()
