extends StaticBody2D

const TILE_SIZE = 16

var speed = 20 
var direction = Vector2.ZERO

var moving = false

var grid_pos: Vector2


func _process(delta: float) -> void:
	grid_pos = floor(global_position / TILE_SIZE)
	print(grid_pos)
	if Input.is_action_just_pressed("block_test_up"):
		print('test')
		moving = true
		direction = Vector2.UP
	
	if moving:
		position += direction * speed * delta
		
