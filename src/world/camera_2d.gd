extends Camera2D

@export var player: CharacterBody2D
@onready var size = Vector2(160, 128)

var moving = false
var movement = Vector2.ZERO
var x_movement_factor = 0
var y_movement_factor = 0


func _process(delta: float) -> void:
	print(player.position)
	global_position += movement
	if moving:
		y_movement_factor += 1
	if y_movement_factor == 128:
		movement = Vector2.ZERO


func _on_camera_area_body_exited(body: Node2D) -> void:
	movement.y = -1
	moving = true
