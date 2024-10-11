extends CharacterBody2D

const SPEED = 85
const KNOCKBACK_SPEED = -250

var health = 6

var direction: Vector2
var knockback_vector: Vector2

var pushing = false
var is_knockback = false

@onready var animation_tree: AnimationTree = $AnimationTree

signal damaged


func _ready() -> void:
	animation_tree.active = true


func _process(delta: float) -> void:
	update_animation_parameters()


func _physics_process(delta: float) -> void: 
	direction = Input.get_vector("left", "right", "up", "down")

	if direction != Vector2.ZERO:
		knockback_vector = direction	

	if is_knockback:
		knockback()
	else:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED

	push()
	
	move_and_slide()


func damage(amount=1):
	health -= amount
	damaged.emit()
	$KnockBackTimer.start()
	is_knockback = true


func knockback():
	velocity.x = knockback_vector.x * KNOCKBACK_SPEED
	velocity.y = knockback_vector.y * KNOCKBACK_SPEED


func push():
	if velocity != Vector2.ZERO:
		if is_on_wall() and velocity.y == 0:
			pushing = true
		elif is_on_floor() and velocity.x == 0:
			pushing = true
		elif is_on_ceiling() and velocity.x == 0:
			pushing = true
		else:
			pushing = false
	else:
		pushing = false


func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
		animation_tree["parameters/conditions/is_pushing"] = false 
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/is_pushing"] = false 
	
	if pushing:
		animation_tree["parameters/conditions/idle"] = false 
		animation_tree["parameters/conditions/is_moving"] = false
		animation_tree["parameters/conditions/is_pushing"] = true

	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
		animation_tree["parameters/Push/blend_position"] = direction


func _on_knock_back_timer_timeout() -> void:
	is_knockback = false	
