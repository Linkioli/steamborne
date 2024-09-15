extends CharacterBody2D

const SPEED = 100

var direction: Vector2
var old_vector: Vector2

@onready var animation_tree: AnimationTree = $AnimationTree


func _ready() -> void:
	animation_tree.active = true


func _process(delta: float) -> void:
	update_animation_parameters()


func _physics_process(delta: float) -> void: 
	direction = Input.get_vector("left", "right", "up", "down")
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED

	push()
	
	move_and_slide()


func push():
	if velocity != Vector2.ZERO:
		if is_on_wall() and velocity.y == 0:
			print(randi())
		elif is_on_floor() and velocity.x == 0:
			print(randi())


func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
