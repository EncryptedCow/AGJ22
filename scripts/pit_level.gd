extends Node2D

onready var player_spawn = $PlayerSpawn

var initial_lines: Array = [
	"I’m so sorry about that. There was supposed to be a kill plane behind the scrolling section, but instead there were some holes in the code.",
	"That lesson is clearly broken, so we had to move on.",
	"Hopefully all the other kill planes should still be working as intended.",
	"Fortunately, the next lesson, obstacles, is all about avoiding kill planes!",
	"Let’s start off with a simple one, use your ‘jump’ command to overcome this pit."
]

var next_line: int = 0

onready var narrator: Narrator = $Narrator

func _ready() -> void:
	Flags.set_flag("can_move", true)
	Flags.set_flag("can_jump", true)
	
	narrator.connect("line_complete", self, "_line_complete")
	narrator.connect("request_next_line", self, "_line_requested")
	_send_next_line()

func _send_next_line():
	if next_line >= initial_lines.size():
		return
	
	narrator.say_line(initial_lines[next_line])
	next_line += 1

var pit_entered_count: int = 0

func _line_requested():
	_send_next_line()

func _line_complete():
	pass

func _on_left_side_entered(body: Node) -> void:
	pass

func _on_pit_entered(body: Node) -> void:
	pit_entered_count += 1
