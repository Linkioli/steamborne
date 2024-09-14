extends StaticBody2D

const SPEED = 0.5

var movement = Vector2.ZERO

func _process(delta: float) -> void:
	position += movement * SPEED


func _on_up_body_entered(body: Node2D) -> void:
	print('test')


func _on_up_body_exited(body: Node2D) -> void:
	print('test2')
