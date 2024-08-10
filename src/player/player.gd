extends CharacterBody2D

const SPEED = 100

var direction: Vector2


func _physics_process(delta: float) -> void: 
	direction = Input.get_vector("left", "right", "up", "down")
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED

	move_and_slide()
