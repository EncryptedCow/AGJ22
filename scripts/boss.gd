extends Area2D

onready var player = get_parent().get_node("Player")
onready var timer = $Timer
onready var raycast = $Sprite/RayCast2D
onready var sprite = $Sprite
onready var attack_spawn = $AttackSpawn
onready var talk_prompt = $TalkPrompt
onready var dialogue = $Dialogue
onready var option_one = $DialogueButtons/Option1
onready var option_two = $DialogueButtons/Option2
onready var dino_roar = $DinoRoar
onready var narrator = get_parent().get_node("Narrator")
onready var tween = $Tween
onready var fader = $CanvasLayer/ColorRect

export (Array, AudioStream) var roar_sounds = []

var laser = preload("res://game_objects/laser.tscn")

var conversation_started = false

func _ready() -> void:
	dialogue.visible = false
	$DialogueButtons.visible = false

func _process(delta: float) -> void:
	if player.position.x > position.x:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	
	if not conversation_started:
		attack_spawn.look_at(player.global_position - Vector2(0, 16))
		if player.position.x > position.x:
			raycast.cast_to = (player.global_position - raycast.global_position) * Vector2(-1, 1) - Vector2(0, 16)
		else:
			raycast.cast_to = player.global_position - raycast.global_position - Vector2(0, 16)
		if get_overlapping_bodies().size() > 0:
			talk_prompt.visible = true
		else:
			talk_prompt.visible = false
	else:
		pass

var dino_lines = [
	"...?",
	"......... f rie n d?",
	"and so dino was very lonely. dino had no one to talk to.",
	"dino guards and guards but no one ever comes.",
	"I like talking to you. you are a good listener.\nI am dino",
	"... friend needs help?",
	"dino... understands. friend needs help leaving.",
	"but friends can't hurt friends.\nhmmm... dino teach. look.",
	"shiny rock... disappear. click.",
	"good. now use for escape."
]

var curr_line = 0

func _show_next_dino_line():
	curr_line += 1
	if curr_line >= dino_lines.size():
		return
	dialogue.text = dino_lines[curr_line]
	dino_roar.stream = roar_sounds[randi() % roar_sounds.size()]
	dino_roar.play()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and get_overlapping_bodies().size() > 0 and not conversation_started:
		narrator.connect("line_complete", self, "_line_completed")
		narrator.connect("request_next_line", self, "_line_requested")
		narrator._finish_cur_line()
		Flags.set_flag("in_battle", false)
		Flags.set_flag("can_move", false)
		Flags.set_flag("can_jump", false)
		Music.play_intro_glitched()
		conversation_started = true
		get_parent().start_convo()
		timer.stop()
		talk_prompt.visible = false
		dialogue.visible = true
		$DialogueButtons.visible = true
		dino_roar.stream = roar_sounds[randi() % roar_sounds.size()]
		dino_roar.play()
		option_one.text = "Friend?"
		option_two.text = "Friend."

func _on_Timer_timeout() -> void:
	var laser_inst = laser.instance()
	var x_dist = abs(player.global_position.x - global_position.x)
	if Flags.has_flag("in_battle") and x_dist > 40:
		laser_inst.position = attack_spawn.position
		if player.position.x > position.x:
			laser_inst.position.x *= -1
		laser_inst.rotation = attack_spawn.rotation
		add_child(laser_inst)

var wait_for_fade: bool = false

var narrator_state: int = 0

func _advance_dialogue() -> void:
	print(curr_line)
	match curr_line:
		0:
			narrator.say_line("Wait, what are you doing?")
			$DialogueButtons.visible = false
			dialogue.visible = false
		2:
			_show_next_dino_line()
		3:
			_show_next_dino_line()
			option_one.text = "Friend, help?"
			option_two.text = "Friend, help."
			option_two.visible = true
		4:
			_show_next_dino_line()
			option_two.visible = false
			option_one.text = "..."
		5:
			_show_next_dino_line()
		6:
			_enable_glitch_blocks()
			_show_next_dino_line()
		7:
			_show_next_dino_line()
			$DialogueButtons.visible = false
			Flags.set_flag("can_move", true)
			Flags.set_flag("can_jump", true)

func _enable_glitch_blocks():
	var glitch_blocks = get_parent().get_node("GlitchBlocks")
	glitch_blocks.get_node("GlitchedRock/AudioStreamPlayer").connect("finished", self, "broke_rock")
	glitch_blocks.visible = true
	for block in get_parent().get_node("GlitchBlocks").get_children():
		block.get_node("CollisionShape2D").set_deferred("disabled", false)

func _line_completed():
	match narrator_state:
		0:
			dialogue.visible = true
			_show_next_dino_line()
			narrator.say_line("I haven’t even implemented the player dialogue UI, or any AI!")
			narrator_state = 1
		2:
			$CanvasLayer.visible = true
			tween.interpolate_property(fader, "color", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1.5)
			tween.start()

var fade_out = true

func broke_rock():
	_show_next_dino_line()

func _line_requested():
	match narrator_state:
		1:
			narrator.say_line("How the hell are you doing this??")
			narrator_state = 2
			dialogue.visible = false

func _on_tween_completed(object: Object, key: NodePath) -> void:
	if fade_out:
		fade_out = false
		tween.remove_all()
		tween.interpolate_property(fader, "color", Color(0, 0, 0, 1), Color(0, 0, 0, 0), 1.5)
		tween.start()
		narrator._finish_cur_line()
	else:
		$CanvasLayer.visible = false
		_show_next_dino_line()
		dialogue.visible = true
		option_two.visible = false
		option_one.text = "..."
		$DialogueButtons.visible = true
