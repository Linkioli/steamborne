extends CharacterBody2D 

const SPEED = 50

@export var up_disabled = false
@export var down_disabled = false
@export var left_disabled = false
@export var right_disabled = false

var movement = Vector2.ZERO

var up = false
var down = false
var left = false
var right = false


func _ready() -> void:
	if up_disabled:
		$Up/CollisionShape2D.disabled = true
	if down_disabled:
		$Down/CollisionShape2D.disabled = true
	if left_disabled:
		$Left/CollisionShape2D.disabled = true
	if right_disabled:
		$Right/CollisionShape2D.disabled = true


func _physics_process(delta: float) -> void:
	if Global.player.pushing:
		# movement in the positive directions is twice as fast because it was moving half the speed for some reason
		if up:
			movement.y = 2
		elif down:
			movement.y = -1
		elif left:
			movement.x = 2
		elif right:
			movement.x = -1
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


func _on_down_body_entered(body: Node2D) -> void:
	down = true


func _on_down_body_exited(body: Node2D) -> void:
	movement = Vector2.ZERO
	down = false


func _on_left_body_entered(body: Node2D) -> void:
	left = true


func _on_left_body_exited(body: Node2D) -> void:
	movement = Vector2.ZERO
	left = false


func _on_right_body_entered(body: Node2D) -> void:
	right = true


func _on_right_body_exited(body: Node2D) -> void:
	movement = Vector2.ZERO
	right = false
