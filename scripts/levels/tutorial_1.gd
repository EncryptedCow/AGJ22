extends Node2D

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
	narrator.connect("line_complete", self, "_line_complete")
	narrator.connect("request_next_line", self, "_line_requested")
	_send_next_line()
	
	Music.play_intro_normal()

func _send_next_line():
	if next_line >= lines.size():
		return
	
	narrator.say_line(lines[next_line])
	next_line += 1

func _line_requested():
	_send_next_line()

func _line_complete():
	if next_line == 5:
		Flags.set_flag("can_move", true)
		$MoveLabel/Tween.interpolate_property($MoveLabel, "rect_scale", Vector2.ZERO, Vector2.ONE, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$MoveLabel/Tween.start()
