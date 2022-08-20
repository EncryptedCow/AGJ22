extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = 350
export (int) var gravity = 800

enum CAMERA_MODE { Follow, AutoScroll }
export (CAMERA_MODE) var camera_mode = CAMERA_MODE.Follow

var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var movement = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = movement * speed
	velocity.y += gravity * delta
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_speed
