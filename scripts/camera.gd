tool
extends Camera2D

export (NodePath) var player_path
onready var player = get_node(player_path)
onready var parallax = get_parent().get_node("Background")

export (float) var y_offset = 100.0
export (float) var scroll_speed = 50.0

var HALF_CAM_WIDTH = (ProjectSettings.get_setting("display/window/size/width") / 2) * 0.5

func _process(delta: float) -> void:
	if player == null:
		return
	
	match player.camera_mode:
		player.CAMERA_MODE.Follow:
			position = player.position - Vector2(0, y_offset)
		player.CAMERA_MODE.AutoScroll:
			if Engine.editor_hint:
				position = Vector2(HALF_CAM_WIDTH, player.position.y - y_offset)
			else:
				if Flags.has_flag("camera_can_scroll"):
					position.x += scroll_speed * delta
				position.y = player.position.y - y_offset
