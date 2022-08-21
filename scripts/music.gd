extends Node

var music_player_scene = preload("res://game_objects/music_player.tscn")
var audio_stream: AudioStreamPlayer

var main_loop_intro = preload("res://audio/music_mainLoopINTRO.wav")
var main_loop = preload("res://audio/music_mainLoopCLEAN.wav")

var glitched_loop_intro = preload("res://audio/music_mainLoopGLITCHEDINTRO.wav")
var glitched_loop = preload("res://audio/music_mainLoopGLITCHED.wav")

func _ready() -> void:
	audio_stream = music_player_scene.instance()
	audio_stream.connect("finished", self, "_track_completed")
	add_child(audio_stream)

func play_intro_normal():
	audio_stream.stream = main_loop_intro
	audio_stream.play()

func play_intro_glitched():
	audio_stream.stream = glitched_loop_intro
	audio_stream.play()

func _track_completed():
	match audio_stream.stream:
		main_loop_intro:
			audio_stream.stream = main_loop
			audio_stream.play()
		main_loop:
			audio_stream.play()
		glitched_loop_intro:
			audio_stream.stream = glitched_loop
			audio_stream.play()
		glitched_loop:
			audio_stream.play()
