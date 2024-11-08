extends CharacterBody2D

enum State {UP, DOWN, LEFT, RIGHT}

var current_state
var speed = 30
var direction: Vector2


func _ready() -> void:
	set_dir()	


func _physics_process(delta: float) -> void:
	match current_state:
		State.UP:
			direction = Vector2.UP
		State.DOWN:
			direction = Vector2.DOWN
		State.LEFT:
			direction = Vector2.LEFT
		State.RIGHT:
			direction = Vector2.RIGHT
	
	if is_colliding():
		set_dir()
	
	velocity = direction * speed
	move_and_slide()


func set_dir():
	match randi() % 4:
		0:
			current_state = State.UP
		1:
			current_state = State.DOWN
		2:
			current_state = State.LEFT
		3:
			current_state = State.RIGHT


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
