extends Area2D

@export var max_lost: int = 5
@export var fade_duration: float = 1.5
@export var gameover_scene: PackedScene

@onready var destroy_player = $"../SoundManager/DestroyPlayer"
@onready var music_player = $"../SoundManager/MusicPlayer"
@onready var gameover_player = $"../SoundManager/GameOverPlayer"
@onready var counter = $"../LostCounter"
@onready var fader: ColorRect = $"../CanvasLayer/ColorRect"

var lost: int = 0

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	counter.text = "0/" + str(max_lost)

func _on_body_entered(body):
	if body is RigidBody2D:
		body.queue_free()
		destroy_player.play()

		lost += 1
		counter.text = str(lost) + "/" + str(max_lost)

		if lost == max_lost:
			music_player.stop()
			gameover_player.play()
			var tween = create_tween()
			tween.tween_property(fader, "modulate:a", 1.0, fade_duration)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.finished.connect(_wait_for_sound_and_change_scene)

func _wait_for_sound_and_change_scene():
	# Wait until the sound stops playing
	if gameover_player.playing:
		await gameover_player.finished
	get_tree().change_scene_to_packed(gameover_scene)
