extends Node

signal glitched_level_complete_finished()
signal level_complete_finished()
signal subversion_clean_complete()
signal subversion_one_complete()
signal subversion_two_complete()
signal subversion_three_complete()

var held_track: AudioStream
var held_playback_position: float = 0.0

var music_player_scene = preload("res://game_objects/music_player.tscn")
var audio_stream: AudioStreamPlayer


var main_loop_intro = preload("res://audio/music_mainLoopINTRO.wav")
var main_loop = preload("res://audio/music_mainLoopCLEAN.wav")

var glitched_loop_intro = preload("res://audio/music_mainLoopGLITCHEDINTRO.wav")
var glitched_loop = preload("res://audio/music_mainLoopGLITCHED.wav")

var long_loop = preload("res://audio/music_mainLoopSTRETCHED.mp3")

var level_complete = preload("res://audio/music_levelComplete.wav")
var glitched_level_complete = preload("res://audio/music_levelCompleteGLITCHED.wav")

var boss_loop = preload("res://audio/music_bossLoop.wav")

var subversion_clean = preload("res://audio/music_subversionCLEAN.wav")
var subversion_glitch1 = preload("res://audio/music_subversionGLITCH1.wav")
var subversion_glitch2 = preload("res://audio/music_subversionGLITCH2.wav")
var subversion_glitch3 = preload("res://audio/music_subversionGLITCH3.wav")

var apotheosis = preload("res://audio/music_ending.wav")

func _ready() -> void:
	audio_stream = music_player_scene.instance()
	audio_stream.connect("finished", self, "_track_completed")
	add_child(audio_stream)

func stop_track():
	audio_stream.stop()

func play_intro_normal():
	if audio_stream.stream == main_loop or audio_stream.stream == main_loop_intro:
		return
	audio_stream.stream = main_loop_intro
	audio_stream.play()

func play_intro_glitched():
	if audio_stream.stream == glitched_loop or audio_stream.stream == glitched_loop_intro:
		return
	audio_stream.stream = glitched_loop_intro
	audio_stream.play()

func play_level_complete():
	held_track = audio_stream.stream
	held_playback_position = audio_stream.get_playback_position()
	audio_stream.stream = level_complete
	audio_stream.play()

func play_glitched_level_complete():
	held_track = audio_stream.stream
	held_playback_position = audio_stream.get_playback_position()
	audio_stream.stream = glitched_level_complete
	audio_stream.play()

func play_subversion_clean():
	held_track = audio_stream.stream
	held_playback_position = audio_stream.get_playback_position()
	audio_stream.stream = subversion_clean
	audio_stream.play()

func play_subversion_one():
	held_track = audio_stream.stream
	held_playback_position = audio_stream.get_playback_position()
	audio_stream.stream = subversion_glitch1
	audio_stream.play()

func play_subversion_two():
	held_track = audio_stream.stream
	held_playback_position = audio_stream.get_playback_position()
	audio_stream.stream = subversion_glitch2
	audio_stream.play()

func play_subversion_three():
	held_track = audio_stream.stream
	held_playback_position = audio_stream.get_playback_position()
	audio_stream.stream = subversion_glitch3
	audio_stream.play()

func play_boss_loop():
	if audio_stream.stream == boss_loop:
		return
	audio_stream.stream = boss_loop
	audio_stream.play()

func play_long_loop():
	audio_stream.stream = long_loop
	audio_stream.play()

func play_apotheosis():
	audio_stream.stream = apotheosis
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
		level_complete:
			audio_stream.stream = held_track
			audio_stream.seek(held_playback_position)
			audio_stream.play()
			emit_signal("level_complete_finished")
		glitched_level_complete:
			audio_stream.stream = held_track
			audio_stream.seek(held_playback_position)
			audio_stream.play()
			emit_signal("glitched_level_complete_finished")
		subversion_clean:
			audio_stream.stream = held_track
			audio_stream.seek(held_playback_position)
			audio_stream.play()
			emit_signal("subversion_clean_complete")
		subversion_glitch1:
			audio_stream.stream = held_track
			audio_stream.seek(held_playback_position)
			audio_stream.play()
			emit_signal("subversion_one_complete")
		subversion_glitch2:
			audio_stream.stream = held_track
			audio_stream.seek(held_playback_position)
			audio_stream.play()
			emit_signal("subversion_two_complete")
		subversion_glitch3:
			audio_stream.stream = held_track
			audio_stream.seek(held_playback_position)
			audio_stream.play()
			emit_signal("subversion_three_complete")
		boss_loop:
			audio_stream.play()
		long_loop:
			audio_stream.play()
		
