class_name Narrator
extends CanvasLayer

signal line_complete()

onready var caption_label: Label = get_node("CenterContainer/Label")
onready var caption_tween: Tween = get_node("CenterContainer/Label/Tween")

export var line_time: float = 2.0

func say_line(text: String):
	caption_label.percent_visible = 0
	caption_label.text = text
	
	caption_tween.interpolate_property(caption_label, "percent_visible", 0, 1, line_time,Tween.TRANS_LINEAR)
	caption_tween.start()

func _on_tween_completed(object: Object, key: NodePath) -> void:
	emit_signal("line_complete")
