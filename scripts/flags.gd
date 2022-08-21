extends Node

var _flags: Dictionary = {
	"can_jump": true
}

func set_flag(name: String, val: bool):
	_flags[name] = val

func has_flag(name: String) -> bool:
	if _flags.has(name):
		return _flags[name]
	else:
		return false
