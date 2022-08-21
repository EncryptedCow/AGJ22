extends Area2D

export (PackedScene) var next_level

export var play_level_complete_sound = false

func _ready() -> void:
	Music.connect("level_complete_finished", self, "_change_level")

func _on_LevelEndTrigger_body_entered(body: Node) -> void:
	if play_level_complete_sound:
		Music.play_level_complete()
	else:
		get_tree().change_scene_to(next_level)

func _change_level():
	if play_level_complete_sound:
		get_tree().change_scene_to(next_level)
