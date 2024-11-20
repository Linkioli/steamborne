extends StaticBody2D

const TILE_SIZE = 16

var speed = 20
var direction = Vector2.ZERO
var moving = false

var initial_pos: Vector2
var target_pos: Vector2
var grid_pos: Vector2

var up = false
var down = false
var left = false
var right = false

var player

var push_timer_finished = false

@export_enum('horizontal', 'vertical') var movement_direction: String = 'horizontal'


# TODO: add y-sort function with player
func _ready() -> void:
	initial_pos = global_position

	if movement_direction == 'horizontal':
		$PushUp/CollisionShape2D.disabled = true
		$PushDown/CollisionShape2D.disabled = true
	if movement_direction == 'vertical':
		$PushLeft/CollisionShape2D.disabled = true
		$PushRight/CollisionShape2D.disabled = true


func _process(delta: float) -> void:
	player = Global.player

	if not moving:
		grid_pos = floor(global_position / TILE_SIZE)
		if grid_pos not in DynamicTiles.occupied_grids:
			DynamicTiles.occupied_grids.append(grid_pos)
		
		if player.current_state == player.State.PUSH:
			if up and Global.player.direction == Vector2.UP:
				push(Vector2.UP)	
			if down and Global.player.direction == Vector2.DOWN:
				push(Vector2.DOWN)	
			if left and Global.player.direction == Vector2.LEFT:
				push(Vector2.LEFT)	
			if right and Global.player.direction == Vector2.RIGHT:
				push(Vector2.RIGHT)	
		else:
			direction = Vector2.ZERO

		if player.current_state != player.State.PUSH:
			$PushTimer.stop()

		# Set the target position and start moving
		if direction != Vector2.ZERO:
			target_pos = global_position + direction * TILE_SIZE
			var target_grid = DynamicTiles.get_grid_position(target_pos)
			moving = grid_availibility(target_grid)
	
	if moving:
		position += direction * speed * delta

		# Check if reached or passed the target position
		if (global_position - target_pos).length() <= speed * delta:
			global_position = target_pos
			moving = false


func grid_availibility(pos):
	if pos in DynamicTiles.occupied_rail_grids:
		return false
	if pos in DynamicTiles.occupied_grids:
		return false
	else:
		DynamicTiles.occupied_grids.erase(grid_pos)
		return true


func push(dir: Vector2):
	if $PushTimer.time_left == 0:
		$PushTimer.start()
	if push_timer_finished:
		direction = dir
		push_timer_finished = false


func reset():
	DynamicTiles.occupied_grids.erase(grid_pos)
	$PushTimer.stop()
	push_timer_finished = false 
	moving = false
	direction = Vector2.ZERO
	global_position = initial_pos
	up = false
	down = false
	left = false
	right = false


func _on_push_timer_timeout() -> void:
	push_timer_finished = true


func _on_push_up_body_entered(body: Node2D) -> void:
	if body == Global.player:
		up = true


func _on_push_up_body_exited(body: Node2D) -> void:
	if body == Global.player:
		up = false
		$PushTimer.stop()


func _on_push_down_body_entered(body: Node2D) -> void:
	if body == Global.player:
		down = true

func _on_push_down_body_exited(body: Node2D) -> void:
	if body == Global.player:
		down = false
		$PushTimer.stop()


func _on_push_left_body_entered(body: Node2D) -> void:
	if body == Global.player:
		left = true


func _on_push_left_body_exited(body: Node2D) -> void:
	if body == Global.player:
		left = false
		$PushTimer.stop()


func _on_push_right_body_entered(body: Node2D) -> void:
	if body == Global.player:
		right = true


func _on_push_right_body_exited(body: Node2D) -> void:
	if body == Global.player:
		right = false
		$PushTimer.stop()
