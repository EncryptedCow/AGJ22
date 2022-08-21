extends Node

signal level_complete_finished()

var held_track: AudioStream
var held_playback_position: float = 0.0

var music_player_scene = preload("res://game_objects/music_player.tscn")
var audio_stream: AudioStreamPlayer

var main_loop_intro = preload("res://audio/music_mainLoopINTRO.wav")
var main_loop = preload("res://audio/music_mainLoopCLEAN.wav")

var glitched_loop_intro = preload("res://audio/music_mainLoopGLITCHEDINTRO.wav")
var glitched_loop = preload("res://audio/music_mainLoopGLITCHED.wav")

var level_complete = preload("res://audio/music_levelComplete.wav")

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

func play_level_complete():
	held_track = audio_stream.stream
	held_playback_position = audio_stream.get_playback_position()
	audio_stream.stream = level_complete
	audio_stream.play()

func play_scuffed_level_complete():
	pass

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
		level_complete:
			audio_stream.stream = held_track
			audio_stream.seek(held_playback_position)
			audio_stream.play()
			emit_signal("level_complete_finished")
