class_name Narrator
extends CanvasLayer

signal line_complete()
signal request_next_line()

onready var caption_label: Label = get_node("CenterContainer/MarginContainer/VBoxContainer/Label")
onready var caption_tween: Tween = get_node("CenterContainer/MarginContainer/VBoxContainer/Label/Tween")

export var line_time: float = 2.0

var line_complete: bool = false

func say_line(text: String):
	line_complete = false
	
	caption_label.percent_visible = 0
	caption_label.text = text
	
	caption_tween.interpolate_property(caption_label, "percent_visible", 0, 1, line_time,Tween.TRANS_LINEAR)
	caption_tween.start()

func _on_tween_completed(object: Object, key: NodePath) -> void:
	line_complete = true
	emit_signal("line_complete")

func finish_line():
	if caption_tween.is_active():
		caption_tween.stop_all()
		caption_label.percent_visible = 1
	else:
		emit_signal("request_next_line")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip_dialogue"):
		finish_line()
