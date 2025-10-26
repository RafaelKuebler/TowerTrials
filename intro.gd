extends Control

@export var main_scene: PackedScene
@export var continue_button: Button
@export var start_button: Button
@export var start_ui: Control
@export var instruction_ui: Control

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)
	start_ui.visible = true
	instruction_ui.visible = false

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(main_scene)

func _on_continue_button_pressed():
	start_ui.visible = false
	instruction_ui.visible = true
