extends Area2D

export var top_speed: float = 100
export var speed_curve: Curve

var lifetime: float = 0.0

var laser_shoot = preload("res://audio/dino_lazor.wav")
var FIRIN_LAZOR = preload("res://audio/imma-firin-mah-lazer-By-Tuna.mp3")

func _ready() -> void:
	if (randi() % 1000) == 69:
		$AudioStreamPlayer.stream = FIRIN_LAZOR
	else:
		$AudioStreamPlayer.stream = laser_shoot
	$AudioStreamPlayer.play()

func _physics_process(delta: float) -> void:
	lifetime += delta
	var curve_val = speed_curve.interpolate(lifetime)
	position += transform.x * top_speed * curve_val * delta

func _on_Laser_body_entered(body: Node) -> void:
	if body.name == "Player":
		get_parent().get_parent().player_hit()
	queue_free()
