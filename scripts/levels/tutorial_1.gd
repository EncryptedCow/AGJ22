extends Node2D

var lines: Array = [
	"Lesson one: Expectations",
	"This is a question asked by designers and programmers the world round!",
	"Everyone wants to know how to design good and proper video games, but new makers often don’t know where to begin.",
	"In this 250 part series of lessons, we will show you the ins and outs of good and proper game design.",
	"…starting from the humblest of beginnings…",
	"the creation and fulfillment of expectations."
]

var next_line: int = 0

onready var narrator: Narrator = $Narrator
onready var timer: Timer = $Timer

func _ready() -> void:
	narrator.connect("line_complete", self, "_line_complete")
	timer.autostart = true
	_send_next_line()

func _line_complete():
	print("line complete")
	timer.start(2.0)

func _send_next_line():
	if next_line >= lines.size():
		return
	
	narrator.say_line(lines[next_line])
	next_line += 1
