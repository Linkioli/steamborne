extends Camera2D

@export var player: CharacterBody2D
@onready var size = Vector2(160, 128)

const SPEED = 2

var moving = false
var movement = Vector2.ZERO
var x_movement_factor = 0
var y_movement_factor = 0


func _process(delta: float) -> void:
	global_position += movement * SPEED
	if movement.y:
		y_movement_factor += SPEED
	if y_movement_factor >= size.y:
		movement = Vector2.ZERO
		y_movement_factor = 0
	if movement.x:
		x_movement_factor += SPEED
	if x_movement_factor >= size.x:
		movement = Vector2.ZERO
		x_movement_factor = 0


func _on_camera_north_trigger_body_entered(body: Node2D) -> void:
	if not moving:
		movement.y = -1


func _on_camera_east_trigger_body_entered(body: Node2D) -> void:
	if not moving:
		movement.x = -1


func _on_camera_south_trigger_body_entered(body: Node2D) -> void:
	if not moving:
		movement.y = 1


func _on_camera_west_trigger_body_entered(body: Node2D) -> void:
	if not moving:
		movement.x = 1
