extends Control

func on_SkipButton_pressed() -> void:
	get_tree().change_scene_to(load("res://levels/Menu.tscn"))

