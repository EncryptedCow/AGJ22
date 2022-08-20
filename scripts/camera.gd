tool
extends Camera2D

export (NodePath) var player_path
onready var player = get_node(player_path)

export (float) var follow_y_offset = 100.0
export (float) var scroll_speed = 100.0

func _process(delta: float) -> void:
	if player == null:
		return
	
	match player.camera_mode:
		player.CAMERA_MODE.Follow:
			position = player.position - Vector2(0, follow_y_offset)
		player.CAMERA_MODE.AutoScroll:
			if Engine.editor_hint:
				position = Vector2(player.x, )
			else:
				position.x += scroll_speed * delta
