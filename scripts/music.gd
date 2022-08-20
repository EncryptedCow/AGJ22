extends Node

var audio_stream: AudioStreamPlayer = AudioStreamPlayer.new()
var main_loop = preload("res://audio/agjMainDRAFT05.mp3")

func _ready() -> void:
	add_child(audio_stream)
	audio_stream.stream = main_loop
	audio_stream.play()
