extends StaticBody2D

const TILE_SIZE = 16

var speed = 20
var direction = Vector2.ZERO
var moving = false

var target_pos: Vector2
var grid_pos: Vector2


func _process(delta: float) -> void:
	if not moving:
		grid_pos = floor(global_position / TILE_SIZE)

		if Input.is_action_just_pressed("block_test_up"):
			direction = Vector2.UP
		elif Input.is_action_just_pressed("block_test_down"):
			direction = Vector2.DOWN
		elif Input.is_action_just_pressed("block_test_left"):
			direction = Vector2.LEFT
		elif Input.is_action_just_pressed("block_test_right"):
			direction = Vector2.RIGHT
		else:
			direction = Vector2.ZERO

		# Set the target position and start moving
		if direction != Vector2.ZERO:
			target_pos = global_position + direction * TILE_SIZE
			print(global_position, target_pos)
			moving = true
	
	if moving:
		position += direction * speed * delta

		# Check if reached or passed the target position
		if (global_position - target_pos).length() <= speed * delta:
			global_position = target_pos
			moving = false
