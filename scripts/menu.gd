extends Control

export (PackedScene) var first_level

func _on_play_pressed() -> void:
	get_tree().change_scene_to(first_level)
