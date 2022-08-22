extends Node2D

func _ready() -> void:
	Flags.set_flag("can_move", false)
	Flags.set_flag("can_jump", false)
	
	narrator.connect("line_complete", self, "_line_complete")
	narrator.connect("request_next_line", self, "_line_requested")
	_send_next_line()
	Music.stop_track()
	
	$GlitchBlocks/GlitchedRock5/AudioStreamPlayer.connect("finished", self, "_break_tile")

onready var narrator = $Narrator

var first_lines = [
	"Oh dear, oh my. I think I see what’s going on.",
	"We have an explorer on our hands.",
	"You really aren’t the type to be railroaded, hmm? A daring adventurer to the end?",
	"Fine. You want to see so dearly what happens when you mess with the natural order?",
	"Lesson 72:",
	"Boss Fights."
]

var hit_dialogue = [
	"Well, aren’t you cute!",
	"Look at you running around. Using your little jump attacks to boop the damn dinosaur.",
	"Sprinting all around the stage hoping to find something, just something.",
	"An item, a weapon, a powerup. Surely something can be used to defeat this final foe!",
	"You really thought this one through didn’t you? You’re a proper glitch master, a greasy little speed runner.",
	"Skipping all the damn levels just to be thrust to an end stage you were never prepared for.",
	"Well I have bad news.",
	"Remember when you skipped the item level, you ingrate?",
	"Imagine if only there were something helpful at the end of the line.",
	"But now, who knows what could have been at the end of that stage?",
	"Me? No, surely not. I’m just some helpless sap that let an anarchist into my proper little project.",
	"If you had let me get to the point on lesson 42, you would have known that good and proper game designers build difficulty spikes into the narrative.",
	"A proper game has mechanical arc's; stages of gradual introduction and exploration! You need to BUILD up to your conclusion, to follow the designer’s progression.",
	"This is why you’re level 0 and fighting a lvl 900 dinosaur.",
	"You have the patience of a petulant child. Idiot.",
	"I should have known you were trying to sabotage this from the beginning.",
	"All the signs pointed to it.",
	"The backtracking. The control fiddling. The suicide attempts.",
	"Now, you’ll pay the consequences.",
	"There are no ways to exit the stage. All you can do is die again and again and again.",
	"Over and over until you either restart the game or delete your operating system out of frustration.",
	"This isn’t your game, it's mine.",
	"Mine, you hear? MINE!",
	"My game, MY hard work, all trashed by some philistine who wouldn’t recognize good design if their head was bashed in with it.",
	"You disgust me."
]

var lines_in_use: Array = first_lines
var next_line: int = 0

func _send_next_line():
	if next_line >= lines_in_use.size():
		return
	
	narrator.say_line(lines_in_use[next_line])
	next_line += 1

func _line_requested():
	_send_next_line()

func _line_complete():
	if lines_in_use == first_lines and next_line == 6:
		Flags.set_flag("can_move", true)
		Flags.set_flag("can_jump", true)
		Flags.set_flag("in_battle", true)
		Music.play_boss_loop()

func player_hit():
	$PlayerHitSound.play()
	$Player.position = $PlayerRespawn.position
	if lines_in_use == first_lines:
		lines_in_use = hit_dialogue
		next_line = 0
		_send_next_line()

func start_convo():
	narrator._finish_cur_line()
	lines_in_use = []

func _break_tile():
	$WorldTiles.set_cell(34, 14, -1)
