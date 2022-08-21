extends Node2D

signal activated

onready var activate_label: Label = $Node2D/ActivateLabel
onready var trigger_area: Area2D = $Area2D

export var enabled = true
var activated = false

func _ready() -> void:
	activate_label.visible = false

func _physics_process(delta: float) -> void:
	if not activated and enabled and trigger_area.get_overlapping_bodies().size() > 0:
		activate_label.visible = true
	else:
		activate_label.visible = false

func deactivate():
	activated = false
	$ButtonSprite.frame = 0

func _input(event: InputEvent) -> void:
	if activated:
		return
	
	if Input.is_action_just_pressed("interact") and trigger_area.get_overlapping_bodies().size() > 0 and enabled:
		$ButtonSprite.frame = 1
		activate_label.visible = false
		activated = true
		emit_signal("activated")
