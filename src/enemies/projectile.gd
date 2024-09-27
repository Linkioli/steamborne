extends Area2D

var direction = Vector2.ZERO

const SPEED = 100

func fire(pos, dir):
	var position = pos	
	match dir:
		'up': direction.y = -1
		'down': direction.y = 1
		'left': direction.x = -1
		'right': direction.x = 1


func _process(delta: float) -> void:
	position += direction * SPEED * delta