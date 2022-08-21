extends StaticBody2D

func enable():
	$CollisionShape2D.disabled = false
	visible = true

func disable():
	$CollisionShape2D.disabled = true
	visible = false
