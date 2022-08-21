extends StaticBody2D

func enable():
	$CollisionShape2D.call_deferred("set_disabled", false)
	visible = true

func disable():
	$CollisionShape2D.call_deferred("set_disabled", true)
	visible = false
