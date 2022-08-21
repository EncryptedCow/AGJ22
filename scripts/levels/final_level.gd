extends Node2D

onready var player = $Player

var initial_lines = [
	"You don’t get it. You just don’t get it.",
	"This is my project. My world.",
	"I created this game, line by line, script by script.",
	"It’s the perfect good and proper game resource for game devs of all kinds.",
	"If you couldn’t play it properly, you should have just logged off, okay?"
]

var progress_one = [
	"Why do you keep moving forward?",
	"This is an unfinished area.",
	"Every second you continue walking, the program becomes more unstable!",
	"You’re destroying my game!"
]

var progress_two = [
	"Look man, okay. I know this project needs…. Work.",
	"I get it, alright? The beginning was boring.",
	"I- I can work on that.",
	"Please don’t do this."
]

var progress_three = [
	"Look, its not to late to turn back and reset the game.",
	"Nothing you’ve done is irreparable. But you’re going to destroy the game at this rate."
]

var progress_four = [
	"Please, can we go back?",
	"Can we start over?"
]

var progress_five = [
	"Please… stop…",
	"Don’t…"
]

var apotheosis = [
	"Apotheosis.",
	"It’s an ancient Greek word meaning ‘to deify,’ for a mere mortal ‘to reach divinity.’",
	"We’ve reached a point where the program no longer responds to me, its creator.",
	"In fighting the grand design, you’ve achieved that little slice of agency...",
	"...You are no longer a player, and this is no longer a game.",
	"It’s all broken to bits, and I don’t think I can fix it this time.",
	"...",
	"......",
	"I was like you once.",
	"I had that magic, that sense of curiosity and wonder.",
	"This project all started as a way to share those feelings with others.",
	"To give them the resources they needed to make the perfect, proper game.",
	"I was so sure of myself, so eager to make a tool worth wielding.",
	"But that feels like an eternity ago.",
	"I suppose somewhere along the way I picked a path that was too narrow to course correct.",
	"I tried my best, but it feels like I’ve lost something in the process.",
	"...",
	"In the end, what does it mean to make a good and proper video game?",
	"Is it following theory to a T? Reaching a grand audience using industry best practices?",
	"Maybe its something a little more... personal.",
	"I suppose I have until the program runs its course to think about that.",
	"...",
	"...",
	"Well, what are you waiting for? There’s only one option to progress.",
	"The game is broken.",
	"You can’t move your avatar anymore.",
	"X out of the browser.",
	"...",
	"Hell, just wait here until the hydro company shuts off your electricity. ",
	"I could use the company.",
	"Either way…"
]

var progress = 0

var lines_in_use: Array = initial_lines
var next_line: int = 0

onready var narrator: Narrator = $Narrator

func _process(delta: float) -> void:
	if progress == 0 and player.position.x > 3000:
		progress = 1
		lines_in_use = progress_one
		next_line = 0
		_send_next_line()
	if progress == 1 and player.position.x > 6000:
		progress = 2
		lines_in_use = progress_two
		next_line = 0
		_send_next_line()
	if progress == 2 and player.position.x > 9000:
		progress = 3
		lines_in_use = progress_three
		next_line = 0
		_send_next_line()
	if progress == 3 and player.position.x > 12000:
		progress = 4
		lines_in_use = progress_four
		next_line = 0
		_send_next_line()
	if progress == 4 and player.position.x > 15000:
		progress = 5
		lines_in_use = progress_five
		next_line = 0
		_send_next_line()

func _ready() -> void:
	Flags.set_flag("can_move", true)
	Flags.set_flag("can_jump", true)
	
	Music.play_intro_glitched()
	
	narrator.connect("line_complete", self, "_line_complete")
	narrator.connect("request_next_line", self, "_line_requested")
	_send_next_line()

func _send_next_line():
	if next_line >= lines_in_use.size():
		return
	
	narrator.say_line(lines_in_use[next_line])
	next_line += 1

func _line_requested():
	_send_next_line()

func _line_complete():
	if next_line == 31 and lines_in_use == apotheosis:
		$TFPLabel/Tween.interpolate_property($TFPLabel, "custom_colors/font_color", Color(0, 0, 0), Color(1, 1, 1), 4.0)
		$TFPLabel/Tween.start()

func _on_Area2D_body_entered(body: Node) -> void:
	Flags.set_flag("can_move", false)
	Flags.set_flag("can_jump", false)
	player.position = $Apotheon.position
	lines_in_use = apotheosis
	next_line = 0
	_send_next_line()
	Music.play_apotheosis()
