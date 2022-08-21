extends Node2D

func _ready() -> void:
	Flags.set_flag("can_move", true)
	Flags.set_flag("can_jump", true)
