tool
extends Node2D

export (PackedScene) var level_to_repeat
export (NodePath) var tracked_object_path
onready var tracked_object = get_node(tracked_object_path).get_node("Node/Camera2D")

var chunk_width: float = 0
var current_chunk: Node2D
var next_chunk: Node2D

var HALF_CAM_WIDTH = (ProjectSettings.get_setting("display/window/size/width") / 2) * 0.5

var lines: Array = [
	"Lesson one: Expectations",
	"This is a question asked by designers and programmers the world round!",
	"Everyone wants to know how to design good and proper video games, but new makers often don’t know where to begin.",
	"In this 250 part series of lessons, we will show you the ins and outs of good and proper game design.",
	"…starting from the humblest of beginnings…",
	"...the creation and fulfillment of expectations."
]

var next_line: int = 0

onready var narrator: Narrator = $Narrator

func _ready() -> void:
	Flags.set_flag("can_move", true)
	Flags.set_flag("can_jump", true)
	
	if has_node("CurrentChunk"):
		get_node("CurrentChunk").queue_free()
		remove_child(get_node("CurrentChunk"))
	
	var scene_inst: RepeatedLevel = level_to_repeat.instance()
	scene_inst.name = "CurrentChunk"
	add_child(scene_inst)
		
	scene_inst.set_owner(get_tree().edited_scene_root)
	
	current_chunk = scene_inst
	
	if not Engine.editor_hint:
		chunk_width = scene_inst.get_chunk_width() * 32
		_create_next_chunk()

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		return
	
	if tracked_object.position.x > next_chunk.position.x:
		current_chunk.name = "PreviousChunk"
		next_chunk.name = "CurrentChunk"
		current_chunk = next_chunk
		next_chunk = null
		_create_next_chunk()
	
	if tracked_object.position.x > current_chunk.position.x + HALF_CAM_WIDTH:
		_delete_prev_chunk()

func _create_next_chunk():
	if has_node("NextChunk"):
		get_node("NextChunk").queue_free()
		remove_child(get_node("NextChunk"))
	
	var scene_inst = level_to_repeat.instance()
	scene_inst.name = "NextChunk"
	add_child(scene_inst)
	scene_inst.set_owner(get_tree().edited_scene_root)
	scene_inst.position.x = current_chunk.position.x + chunk_width
	next_chunk = scene_inst

func _delete_prev_chunk():
	if not has_node("PreviousChunk"):
		return
	
	get_node("PreviousChunk").queue_free()
	remove_child(get_node("PreviousChunk"))
