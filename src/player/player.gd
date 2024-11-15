extends CharacterBody2D

const SPEED = 85
const KNOCKBACK_SPEED = -250

var health = 6

var direction: Vector2
var knockback_vector: Vector2

var is_knockback = false
var attacking = false

var current_state
enum State {IDLE, WALK, PUSH, STAB}

signal damaged

@onready var animation_tree: AnimationTree = $AnimationTree


func _ready() -> void:
	animation_tree.active = true


func _process(delta: float) -> void:
	update_animation_parameters()


func _physics_process(delta: float) -> void: 
	direction = Input.get_vector("left", "right", "up", "down")
	if attacking:
		direction = Vector2.ZERO

	if direction != Vector2.ZERO:
		knockback_vector = direction	

	if is_knockback:
		knockback()
	else:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED

	state_machine()
	
	move_and_slide()


func damage(amount=1):
	health -= amount
	damaged.emit()
	$KnockBackTimer.start()
	is_knockback = true


func knockback():
	velocity.x = knockback_vector.x * KNOCKBACK_SPEED
	velocity.y = knockback_vector.y * KNOCKBACK_SPEED


func attack_finished():
	attacking = false


func state_machine():
	if velocity == Vector2.ZERO:
		if not attacking:
			current_state = State.IDLE

	if velocity != Vector2.ZERO and not attacking:
		if is_on_wall() and velocity.y == 0:
			current_state = State.PUSH
		elif is_on_floor() and velocity.x == 0:
			current_state = State.PUSH
		elif is_on_ceiling() and velocity.x == 0:
			current_state = State.PUSH
		else:
			current_state = State.WALK
	
	if Input.is_action_just_pressed('attack'):
		if not attacking:
			attacking = true
			current_state = State.STAB


func update_animation_parameters():
	match current_state:
		State.IDLE:
			animation_tree["parameters/conditions/idle"] = true
			animation_tree["parameters/conditions/is_moving"] = false
			animation_tree["parameters/conditions/is_pushing"] = false 
			animation_tree['parameters/conditions/is_stabbing'] = false
		State.WALK:
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/is_moving"] = true
			animation_tree["parameters/conditions/is_pushing"] = false 
			animation_tree['parameters/conditions/is_stabbing'] = false
		State.PUSH:
			animation_tree["parameters/conditions/idle"] = false 
			animation_tree["parameters/conditions/is_moving"] = false
			animation_tree["parameters/conditions/is_pushing"] = true
			animation_tree['parameters/conditions/is_stabbing'] = false
		State.STAB:
			animation_tree["parameters/conditions/idle"] = false 
			animation_tree["parameters/conditions/is_moving"] = false
			animation_tree["parameters/conditions/is_pushing"] = false
			animation_tree['parameters/conditions/is_stabbing'] = true

	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
		animation_tree["parameters/Push/blend_position"] = direction
		animation_tree["parameters/Stab/blend_position"] = direction


func _on_knock_back_timer_timeout() -> void:
	is_knockback = false	


func _on_animation_player_animation_changed(old_name: StringName, new_name: StringName) -> void:
	print('test')
