class_name Narrator
extends CanvasLayer

signal line_complete()
signal request_next_line()

onready var caption_label: Label = $MarginContainer/VBoxContainer/DialogueLabel
onready var caption_tween: Tween = $MarginContainer/VBoxContainer/DialogueLabel/Tween

onready var skip_label: Label = $MarginContainer/VBoxContainer/SkipLabel

onready var timer: Timer = $Timer

export var line_time: float = 2.0
export var auto_next_line: float = 2.0

var line_complete: bool = false

func say_line(text: String):
	if caption_tween.is_active():
		caption_tween.stop_all()
		caption_label.percent_visible = 1
		line_complete = true
		emit_signal("line_complete")
		_reset_timer()
	
	line_complete = false
	
	caption_label.percent_visible = 0
	caption_label.text = text
	
	caption_tween.remove_all()
	caption_tween.interpolate_property(caption_label, "percent_visible", 0, 1, line_time, Tween.TRANS_LINEAR)
	caption_tween.start()
	
	skip_label.visible = true

func _on_tween_completed(object: Object, key: NodePath) -> void:
	line_complete = true
	caption_tween.remove_all()
	_reset_timer()
	emit_signal("line_complete")

func _finish_cur_line():
	if caption_tween.is_active():
		caption_tween.stop_all()
		caption_label.percent_visible = 1
		line_complete = true
		emit_signal("line_complete")
		_reset_timer()
	else:
		emit_signal("request_next_line")
		if line_complete:
			caption_label.text = ""
			skip_label.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip_dialogue"):
		_finish_cur_line()

func _reset_timer():
	timer.stop()
	timer.start(auto_next_line)
	timer.paused = false

func _on_timer_timeout() -> void:
	emit_signal("request_next_line")
	if line_complete:
			caption_label.text = ""
			skip_label.visible = false
