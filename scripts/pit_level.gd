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
	"The only way to get to your precious button is a whole new obstacle."
]

var before_first_kick_lines: Array = [
	"Go on, do it.",
	"It’s just a digital image right? Nothing to worry about.",
	"Don’t want to press the button?",
	"Just X out of your browser and restart the game. Maybe we can get back on track.",
	"You’re so invested in breaking the rules, right?",
	"Well, let’s throw in some ethical rules while we’re at it!"
]

var first_kick_lines: Array = [
	"Oh come now, you barely tapped it with your foot.",
	"You can do better than that, right?"
]

var second_kick_lines: Array = [
	"You heartless bastard."
]

var lines_in_use: Array = initial_lines
var next_line: int = 0

onready var narrator: Narrator = $Narrator

func _ready() -> void:
	Flags.set_flag("can_move", true)
	Flags.set_flag("can_jump", true)
	
	Music.connect("glitched_level_complete_finished", self, "_glitched_level_complete_finished")
	
	narrator.connect("line_complete", self, "_line_complete")
	narrator.connect("request_next_line", self, "_line_requested")
	_send_next_line()
	
	$Button.enabled = false
	$Button.visible = false
	$Bridge.disable()

func _send_next_line():
	if next_line >= lines_in_use.size():
		return
	
	narrator.say_line(lines_in_use[next_line])
	next_line += 1

var pit_entered_count: int = 0

func _line_requested():
	_send_next_line()

func _line_complete():
	if lines_in_use == third_jump_lines and next_line == 4:
		get_node("Puppy").enabled = true
		lines_in_use = before_first_kick_lines
		next_line = 0
#		_send_next_line()

func _on_left_side_entered(body: Node) -> void:
	Flags.set_flag("can_move", false)
	Music.play_glitched_level_complete()

func _glitched_level_complete_finished():
	Flags.set_flag("can_move", true)
	$Player.position = player_spawn.position

func _on_pit_entered(body: Node) -> void:
	pit_entered_count += 1
	$Player.position = player_spawn.position
	
	match pit_entered_count:
		1:
			lines_in_use = first_jump_lines
		2:
			lines_in_use = second_jump_lines
			$Bridge.enable()
			$Button.call_deferred("set_visible", true)
			$Button.enabled = true
		3:
			lines_in_use = third_jump_lines
			$Button.deactivate()
			$Button.enabled = false
			$Bridge.enable()
			$Player.position = $ButtonLocation.position
			var puppy = preload("res://game_objects/puppy.tscn").instance()
			puppy.position = $Button.position
			puppy.connect("puppy_kicked", self, "_on_puppy_kicked")
			add_child(puppy)
			Flags.set_flag("can_move", false)
		4:
			get_tree().change_scene_to(preload("res://levels/boss_level.tscn"))
	
	next_line = 0
	_send_next_line()

func _on_button_activated() -> void:
	$Bridge.disable()

func _on_puppy_kicked():
	var puppy = get_node("Puppy")
	if puppy.kick_counter == 1:
		lines_in_use = first_kick_lines
	if puppy.kick_counter == 2:
		lines_in_use = second_kick_lines
		Flags.set_flag("can_move", true)
		get_node("Puppy").enabled = false
		$Button.enabled = true
	
	next_line = 0
	_send_next_line()
