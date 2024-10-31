extends StaticBody2D

const TILE_SIZE = 16

var speed = 20
var direction = Vector2.ZERO
var moving = false

var target_pos: Vector2
var grid_pos: Vector2

var up = false
var down = false
var left = false
var right = false

var push_timer_finished = false

func _process(delta: float) -> void:
	if not moving:
		grid_pos = floor(global_position / TILE_SIZE)
		if grid_pos not in DynamicTiles.occupied_grids:
			DynamicTiles.occupied_grids.append(grid_pos)
		
		if Global.player.pushing and $PushCoolDownTimer.time_left == 0:
			if up and Global.player.direction == Vector2.UP:
				push(Vector2.UP)	
		else:
			direction = Vector2.ZERO

		if not Global.player.pushing:
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
			$PushCoolDownTimer.start()


func grid_availibility(pos):
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


func _on_push_timer_timeout() -> void:
	push_timer_finished = true


func _on_push_up_body_entered(body: Node2D) -> void:
	if body == Global.player:
		up = true


func _on_push_up_body_exited(body: Node2D) -> void:
	if body == Global.player:
		up = false
		$PushTimer.stop()
