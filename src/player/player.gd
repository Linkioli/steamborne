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

	jittercheck()
	move_and_slide()


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


# This function removes jittering for diagnal movement in these types of "pixel-perfect" 
# Reddit post explination: https://www.reddit.com/r/godot/comments/16lft93/fix_for_pixelperfect_diagonal_movement_causing/

func jittercheck():
	if old_vector != direction:
		old_vector = direction
		if direction != Vector2.ZERO:
			position.x = round(position.x)
			position.y = round(position.y)

