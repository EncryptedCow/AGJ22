class_name RepeatedLevel
extends Node2D

func get_chunk_width() -> float:
	var rect = $WorldTiles.get_used_rect()
	return rect.size.x
