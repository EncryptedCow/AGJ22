extends Area2D

export (PackedScene) var next_level

func _on_LevelEndTrigger_body_entered(body: Node) -> void:
	get_tree().change_scene_to(next_level)
