extends Control

export (PackedScene) var first_level 
export (PackedScene) var credits_list

func _on_play_pressed() -> void:
	get_tree().change_scene_to(first_level)


func _on_Credits_pressed() -> void:
	get_tree().change_scene_to(credits_list)
