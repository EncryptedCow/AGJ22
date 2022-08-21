extends Area2D

var enabled = false
var kick_counter = 0

func enable():
	$CollisionShape2D.disabled = false
	$ActionLabel.visible = true
	enabled = true

func disable():
	$CollisionShape2D.disabled = true
	$ActionLabel.visible = false
	enabled = false

func _on_body_entered(body: Node) -> void:
	if enabled:
		$ActionLabel.visible = true


func _ony_body_exited(body: Node) -> void:
	$ActionLabel.visible = false
