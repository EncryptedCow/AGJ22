extends Node2D

var lines: Array = [
	"Gamers expect a lot from their games.",
	"Whether seeking exhilarating gameplay, interesting narratives, or fascinating mechanics…",
	"…everyone gets something from playing a good and proper video game!",
	"However, at a fundamental level, game’s are about loops of ‘fulfillment.’",
	"When players are given ideas and mechanics to play around with, they expect to be able to use them!",
	"In other forms of media, this concept is often called ‘Chekov’s gun.’",
	"It’s the idea that if a writer includes an object or concept (like a gun) in their scene…",
	"…it needs to be used at some point later on."
]

var next_line: int = 0

onready var narrator: Narrator = $Narrator
onready var timer: Timer = $Timer

func _ready() -> void:
	narrator.connect("line_complete", self, "_line_complete")
	narrator.connect("request_next_line", self, "_line_requested")
	_send_next_line()

func _send_next_line():
	if next_line >= lines.size():
		return
	
	narrator.say_line(lines[next_line])
	next_line += 1

func _line_requested():
	_send_next_line()

func _line_complete():
	if next_line == 7:
		Flags.set_flag("can_jump", true)
		$JumpLabel/Tween.interpolate_property($JumpLabel, "rect_position", Vector2(170, 570), Vector2(170, 480), 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		$JumpLabel/Tween.start()
