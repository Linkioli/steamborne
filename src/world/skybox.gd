extends Node2D

var speed = 0.0025

func _process(delta: float) -> void:
	$Path2D/PathFollow2D.progress_ratio += speed * delta
