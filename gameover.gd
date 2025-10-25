extends Control

@export var game_scene_path: String = "res://main.tscn"
@export var hamster_texture: Array[Texture2D]

@onready var restart_button: Button = $CenterContainer/VBoxContainer/Button
@onready var hamster: TextureRect = $CenterContainer/VBoxContainer/TextureRect

func _ready():
	if hamster:
		hamster.texture = hamster_texture.pick_random()
	restart_button.pressed.connect(_on_restart_button_pressed)

func _on_restart_button_pressed():
	get_tree().change_scene_to_file(game_scene_path)
