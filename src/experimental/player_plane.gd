extends CharacterBody3D


const SPEED = 2
const ROTATION_SPEED = 2

var rotation_dir: int


func _physics_process(delta: float) -> void:
	var movement_vector = Vector3()
	if Input.is_action_pressed("up"):
		movement_vector.z -= 1

	if Input.is_action_pressed("left"):
		rotation_dir = -1
	elif Input.is_action_pressed("right"):
		rotation_dir = 1
	else:
		rotation_dir = 0

	rotation_degrees.y -= rotation_dir * ROTATION_SPEED
	movement_vector = movement_vector.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(movement_vector * SPEED * delta)
