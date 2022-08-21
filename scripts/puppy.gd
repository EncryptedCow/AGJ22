extends RigidBody2D

signal puppy_kicked()

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

func _physics_process(delta: float) -> void:
	if enabled and $Area2D.get_overlapping_bodies().size() > 0:
		$ActionLabel.visible = true
	else:
		$ActionLabel.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and $Area2D.get_overlapping_bodies().size() > 0 and enabled:
		kick_counter += 1
		$DogSprite.frame = kick_counter
		emit_signal("puppy_kicked")
		
		if kick_counter == 1:
			$AudioStreamPlayer.stream = preload("res://audio/puppy/dog_whine.wav")
			$AudioStreamPlayer.play()
		
		if kick_counter == 2:
			$AudioStreamPlayer.stream = preload("res://audio/puppy/dog_yeeted.wav")
			$AudioStreamPlayer.play()
			mode = RigidBody2D.MODE_RIGID
			apply_impulse(Vector2(0, 8), Vector2(100, -150))
			apply_torque_impulse(5000)
