extends Node2D

signal activated

onready var activate_label: Label = $Node2D/ActivateLabel
onready var trigger_area: Area2D = $Area2D

var activated = false

func _ready() -> void:
	activate_label.visible = false

func _on_body_entered(body: Node) -> void:
	activate_label.rect_position = Vector2(-67, -10) + Vector2(rand_range(-20, 20), rand_range(-10, 10))
	activate_label.rect_rotation = rand_range(-20, 20)
	activate_label.visible = true

func _on_body_exited(body: Node) -> void:
	activate_label.visible = false

func _input(event: InputEvent) -> void:
	if activated:
		return
	
	if Input.is_action_just_pressed("interact") and trigger_area.get_overlapping_bodies().size() > 0:
		print("activated")
		$ButtonSprite.frame = 1
