tool
extends Node2D

export (PackedScene) var level_to_repeat
export (NodePath) var tracked_object_path
onready var tracked_object = get_node(tracked_object_path).get_node("Node/Camera2D")

onready var end_trigger = $LevelEndTrigger

var chunk_width: float = 0
var current_chunk: Node2D
var next_chunk: Node2D

var HALF_CAM_WIDTH = (ProjectSettings.get_setting("display/window/size/width") / 2) * 0.5

var lines: Array = [
	"What makes for an interesting story?",
	"One of the important things to remember while writing your game is that players will often perceive and follow elements of game design very closely.",
	"In other words; they play by the ‘rules’.",
	"When signaled properly, following conventions established by past games becomes intuitive for players.",
	"Good game designers have the player’s best interests in mind, so players often don’t need to worry about challenging the narrative at all.",
	"When conflicts arise between programmer and user, immersion is broken and the game is no longer fun.",
	"Narrative architecture is a topic that has been researched extensively by both game designers and before them, literary scholars.",
	"One of the most popular narrative structures is the ‘hero’s journey,’ or the ‘monomyth.’",
	"This idea was first posited by Joseph Campbell, who explains that throughout history, humans have used the same structures to build their stories.",
	"These myths usually involve a main protagonist, or hero, who ventures into the unknown to overcome an obstacle and returns having been changed for the better.",
	"Their quest is often triggered by the hero’s ‘call to adventure’ into a strange and unfamiliar environment.",
	"Some stories propose that character’s should seek to subvert this model, but it is the author’s opinion that this approach is overrated.",
	"After all, if it isn’t broken, why fix it?",
	"At the end of the day, the game’s level of engagement is determined by how accurately a designer can line up their narrative arc to the universal monomyth.",
	"There need to be heroes and villains in games, and tools to help along the way!",
	"",
	"A debate that constantly arises around the topic of storytelling, especially in the context of games, is the subject of choice.",
	"The philosophical notion of ‘free will’ is often ignored in the context of literary analysis.",
	"After all, what character in a book or a movie has a choice about the outcome?",
	"While we may temporarily suspend our disbelief and become emotionally invested in their actions, at the end of the day the plot is written; the end is established.",
	"In video games, we are presented with the problem of interactivity.",
	"Interactivity is the idea that players can affect the outcome of a digital system through interaction with that system.",
	"For example, in lesson one, we allowed the player to press a button that created a pre-programmed outcome.",
	"We can imagine a scenario in which there were multiple buttons leading to different outcomes, thus giving the player a ‘choice.’",
	"Games that do not provide ‘choices’ to players are often accused of being stale or linear.",
	"In game culture, this notion is called ‘railroading.’",
	"Players are ‘railroaded’ down certain plot lines, usually when given no other option but to progress through a particular strategy or movement.",
	"However, we contend that the idea that good and proper videogames are capable of not being ‘rail-roaded’ is silly.",
	"Pre-planned and linear narratives usually of superior quality.",
	"Furthermore, in order to get the most out of good and proper game content, players will always engage with pre-written scripts.",
	"Take, for example, this level. Some might say that you are being ‘railroaded’ to the item at the end of the level.",
	"Of course, technically there is still a choice involved.",
	"One might choose to sit still for the whole level.",
	"A player could also walk the exact opposite direction that the screen is moving and kill his/herself.",
	"You can also always just exit the browser or turn off your computer.",
	"The question is, are these real choices? Of course not.",
	"In any case, let’s get back to the task at hand.",
	"Narrative satisfaction is an extremely important tool for producing and engaging with good and proper games.",
	"In order for players to have fun in the systems you create, they need to follow the rules.",
	"I’ll move on ahead now, and wait for you at the item at the end of the level.",
	"See you soon!"
]

var checkpoint_lines = [
	"Aaaaany minute now…",
	"Yep. Just keep on going. Almost there.",
	"Look at you go! You’re going to love this item. Seriously."
]

var completed_big_ass_dialogue = false
var line_end_x: float = 100000000

var next_line: int = 0

onready var narrator: Narrator = $Narrator

func _ready() -> void:
	if has_node("CurrentChunk"):
		get_node("CurrentChunk").queue_free()
		remove_child(get_node("CurrentChunk"))
	
	var scene_inst: RepeatedLevel = level_to_repeat.instance()
	scene_inst.name = "CurrentChunk"
	add_child(scene_inst)
		
	scene_inst.set_owner(get_tree().edited_scene_root)
	
	current_chunk = scene_inst
	
	narrator.connect("line_complete", self, "_line_complete")
	narrator.connect("request_next_line", self, "_line_requested")
	
	if not Engine.editor_hint:
		chunk_width = scene_inst.get_chunk_width() * 32
		_create_next_chunk()
		Flags.set_flag("can_move", true)
		Flags.set_flag("can_jump", true)
		Flags.set_flag("left_scroll_level_early", true)
		_send_next_line()

func _send_next_line():
	if not completed_big_ass_dialogue:
		if next_line >= lines.size():
			return
		
		narrator.say_line(lines[next_line])
		next_line += 1

func _line_requested():
	_send_next_line()

func _line_complete():
	match next_line:
		8:
			$Arrows.visible = true
			Flags.set_flag("camera_can_scroll", true)
		15:
			Flags.set_flag("left_scroll_level_early", false)
		41:
			line_end_x = tracked_object.position.x
			completed_big_ass_dialogue = true

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
	
	if Flags.has_flag("camera_can_scroll"):
		end_trigger.position.x = tracked_object.position.x - HALF_CAM_WIDTH - (32 * 2.5)
	
	if completed_big_ass_dialogue and tracked_object.position.x > line_end_x + 500:
		line_end_x = tracked_object.position.x
		if checkpoint_lines.size() > 0:
			narrator.say_line(checkpoint_lines.pop_front())

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
