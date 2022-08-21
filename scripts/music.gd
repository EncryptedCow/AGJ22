extends Node

var music_player_scene = preload("res://game_objects/music_player.tscn")
var main_loop = preload("res://audio/agjMainDRAFT05.mp3")

func _ready() -> void:
	var audio_stream = music_player_scene.instance()
	add_child(audio_stream)
	audio_stream.stream = main_loop
	audio_stream.play()
