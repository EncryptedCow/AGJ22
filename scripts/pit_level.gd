extends Node2D

onready var player_spawn = $PlayerSpawn

var initial_lines: Array = [
	"I’m so sorry about that. There was supposed to be a kill plane behind the scrolling section, but instead there were some holes in the code.",
	"That lesson is clearly broken, so we had to move on.",
	"Hopefully all the other kill planes should still be working as intended.",
	"Fortunately, the next lesson, obstacles, is all about avoiding kill planes!",
	"Let’s start off with a simple one, use your ‘jump’ command to overcome this pit."
]

var first_jump_lines: Array = [
	"Ah, haha. I think you might have misunderstood me.",
	"I said to jump over the pit. Not into the pit.",
	"Don’t worry, we can try again."
]

var second_jump_lines: Array = [
	"No, no no! You’re not following the proper narrative arc!",
	"Fine, I’ll make it easy for you.",
	"Simply cross the bridge. That’s all you have to do."
]

var third_jump_lines: Array = [
	"You want to play hard ball? You want to make real, impact-filled decisions in this game?",
	"Fine. Let’s play hardball.",
	"Here’s a choice for you:",
	"I’ve disabled the jump mechanic.",
	"The only way to get to your precious button is a whole new obstacle."
]

var lines_in_use: Array = initial_lines
var next_line: int = 0

onready var narrator: Narrator = $Narrator

func _ready() -> void:
	Flags.set_flag("can_move", true)
	Flags.set_flag("can_jump", true)
	
	narrator.connect("line_complete", self, "_line_complete")
	narrator.connect("request_next_line", self, "_line_requested")
	_send_next_line()

func _send_next_line():
	if next_line >= lines_in_use.size():
		return
	
	narrator.say_line(lines_in_use[next_line])
	next_line += 1

var pit_entered_count: int = 0

func _line_requested():
	_send_next_line()

func _line_complete():
	pass

func _on_left_side_entered(body: Node) -> void:
	pass

func _on_pit_entered(body: Node) -> void:
	print("pit entered")
	pit_entered_count += 1
	
	match pit_entered_count:
		1:
			lines_in_use = first_jump_lines
		2:
			lines_in_use = second_jump_lines
		3:
			lines_in_use = third_jump_lines
