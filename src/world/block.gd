extends CharacterBody2D 

const SPEED = 50

var movement = Vector2.ZERO

var up = false
var down = false
var left = false
var right = false


func _physics_process(delta: float) -> void:
	if Global.player.pushing:
		if up:
			movement.y = 1
		else:
			movement = Vector2.ZERO

	if not Global.player.pushing:
		movement = Vector2.ZERO

	velocity = movement * SPEED
	move_and_slide()


func _on_up_body_entered(body: Node2D) -> void:
	up = true


func _on_up_body_exited(body: Node2D) -> void:
	movement = Vector2.ZERO
	up = false
