extends CharacterBody2D

enum State {UP, DOWN, LEFT, RIGHT}

var current_state
var speed = 50
var health = 2
var direction: Vector2

const EXCLUDE_UP = 0
const EXCLUDE_DOWN = 1
const EXCLUDE_LEFT = 2
const EXCLUDE_RIGHT = 3


# TODO: Add health and damage logic
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
		EXCLUDE_UP:
			if exclude != 0:
				current_state = State.UP
		EXCLUDE_DOWN:
			if exclude != 1:
				current_state = State.DOWN
		EXCLUDE_LEFT:
			if exclude != 2:
				current_state = State.LEFT
		EXCLUDE_RIGHT:
			if exclude != 3:
				current_state = State.RIGHT


func set_collision_dir():
	if is_on_wall():
		if current_state == State.RIGHT:
			set_dir(EXCLUDE_RIGHT)
		elif current_state == State.LEFT:
			set_dir(EXCLUDE_LEFT)

	elif is_on_floor():
		set_dir(EXCLUDE_DOWN)
	elif is_on_ceiling():
		set_dir(EXCLUDE_RIGHT)



func is_colliding():
	if is_on_wall():
		return true
	elif is_on_floor():
		return true
	elif is_on_ceiling():
		return true
	else:
		return false


func damage():
	health -= 1
	print(health)


func _on_move_timer_timeout() -> void:
	set_dir()
	$MoveTimer.start()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.damage()


func _on_hitbox_damaged(amount: Variant) -> void:
	damage()
