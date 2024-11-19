extends CharacterBody2D

const EXCLUDE_UP = 0
const EXCLUDE_DOWN = 1
const EXCLUDE_LEFT = 2
const EXCLUDE_RIGHT = 3

const KNOCKBACK_SPEED = 250

enum State {UP, DOWN, LEFT, RIGHT}

var current_state
var speed = 50
var health = 2
var direction: Vector2
var knockback_vector: Vector2
var is_knockback = false



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

	if is_knockback:
		knockback()
	else:
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
	if health > 0:
		health -= 1
		knockback_vector = Global.player.idle_direction
		is_knockback = true
		$KnockBackTimer.start()
		print(health)
	elif health <= 0:
		print('IM FUCKING DEAD!!!')


func knockback():
	velocity.x = knockback_vector.x * KNOCKBACK_SPEED
	velocity.y = knockback_vector.y * KNOCKBACK_SPEED


func _on_move_timer_timeout() -> void:
	set_dir()
	$MoveTimer.start()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.damage()


func _on_hitbox_damaged(amount: Variant) -> void:
	damage()


func _on_knock_back_timer_timeout() -> void:
	is_knockback = false
