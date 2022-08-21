extends Area2D

export (Array, AudioStream) var break_sounds = []

func _on_GlitchedRock_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		$AudioStreamPlayer.stream = break_sounds[randi() % break_sounds.size()]
		$AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished() -> void:
	queue_free()
