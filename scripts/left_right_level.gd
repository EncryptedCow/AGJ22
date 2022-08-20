tool
extends Node2D

export (PackedScene) var level_to_repeat
export (NodePath) onready var tracked_object = get_node(tracked_object)

func _ready() -> void:
	
	if not has_node("CurrentChunk"):
		var scene_inst = level_to_repeat.instance()
		scene_inst.name = "CurrentChunk"
		add_child(scene_inst)
		
		scene_inst.set_owner(get_tree().edited_scene_root)

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		return
