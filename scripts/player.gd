extends KinematicBody2D

export (int) var run_speed = 200
export (int) var walk_speed = 80
export (int) var jump_speed = 350
export (int) var gravity = 800

enum CAMERA_MODE { Follow, AutoScroll }
export (CAMERA_MODE) var camera_mode = CAMERA_MODE.Follow

var velocity := Vector2.ZERO

export var anim_override: bool = false

func _physics_process(delta: float) -> void:
	var movement = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var speed = walk_speed if Flags.has_flag("walking") else run_speed
	velocity.x = movement * speed
	velocity.y += gravity * delta
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	if Input.is_action_just_pressed("jump") and Flags.has_flag("can_jump"):
		if is_on_floor():
			velocity.y = -jump_speed

func _process(delta: float) -> void:
	var sprite: Sprite = get_node("Sprite")
	var animator: AnimationPlayer = get_node("AnimationPlayer")
	
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
	
	if not anim_override:
		if not is_on_floor():
			animator.play("jump")
		elif abs(velocity.x) > 0:
			if abs(velocity.x) < 100:
				animator.play("walk")
			else:
				animator.play("run")
		else:
			animator.play("idle")
