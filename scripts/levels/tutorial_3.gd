extends Node2D

var lines: Array = [
	"While there are plenty of ‘creative’ and ‘experimental’ ways to convey expectations to the player…",
	"It is best practice to simply lay everything out for them.",
	"Sometimes players struggle with basic mechanics and need blueprints on how to progress.",
	"This is a big problem for designers that need players to understand the basic rules of their games.",
	"Therefore, good and proper games instruct the player on how to properly play the game."
]

var next_line: int = 0

onready var narrator: Narrator = $Narrator

func _ready() -> void:
	Flags.set_flag("can_move", true)
	Flags.set_flag("can_jump", true)
	
	narrator.connect("line_complete", self, "_line_complete")
	narrator.connect("request_next_line", self, "_line_requested")
	_send_next_line()
	
	$Bridge.disable()
	
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
		$Button.enabled = true
		$Button.check_show_prompt()

func _on_button_activated() -> void:
	$Bridge.enable()
