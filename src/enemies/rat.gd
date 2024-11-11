extends CharacterBody2D

enum State {UP, DOWN, LEFT, RIGHT}

var current_state
var speed = 50
var direction: Vector2


func _ready() -> void:
	set_dir()	


func _physics_process(delta: float) -> void:
	match current_state:
		State.UP:
			$AnimationPlayer.play('up')
			direction = Vector2.UP
		State.DOWN:
			$AnimationPlayer.play('down')
			direction = Vector2.DOWN
		State.LEFT:
			$AnimationPlayer.play('left')
			direction = Vector2.LEFT
		State.RIGHT:
			$AnimationPlayer.play('right')
			direction = Vector2.RIGHT
	
	if is_colliding():
		set_collision_dir()
	
	velocity = direction * speed
	move_and_slide()


func set_dir(exclude: int = -1):
	match randi() % 4:
		0:
			if exclude != 0:
				current_state = State.UP
		1:
			if exclude != 1:
				current_state = State.DOWN
		2:
			if exclude != 2:
				current_state = State.LEFT
		3:
			if exclude != 3:
				current_state = State.RIGHT


func set_collision_dir():
	# Exclude values
	# func set_dir(exclude=0)
	# 0 = UP
	# 1 = DOWN
	# 2 = LEFT
	# 3 = RIGHT
	if is_on_wall():
		if current_state == State.RIGHT:
			set_dir(3)
		elif current_state == State.LEFT:
			set_dir(2)

	elif is_on_floor():
		set_dir(1)
	elif is_on_ceiling():
		set_dir(0)



func is_colliding():
	if is_on_wall():
		return true
	elif is_on_floor():
		return true
	elif is_on_ceiling():
		return true
	else:
		return false


func _on_move_timer_timeout() -> void:
	set_dir()
	$MoveTimer.start()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.damage()
