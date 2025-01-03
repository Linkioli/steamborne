extends Camera2D

@export var player: CharacterBody2D
@onready var size = Vector2(256, 224)

const SPEED = 4

var moving = false
var x_movement_factor = 0
var y_movement_factor = 0
var movement = Vector2.ZERO

signal pixel_transition_finished

# TODO: fix this camera movement

func _process(delta: float) -> void:
	global_position += movement * SPEED
	if movement.y:
		y_movement_factor += SPEED
		get_tree().paused = true
	if y_movement_factor >= size.y:
		moving = false
		movement = Vector2.ZERO
		y_movement_factor = 0
		get_tree().paused = false
	if movement.x:
		x_movement_factor += SPEED
		get_tree().paused = true
	if x_movement_factor >= size.x:
		moving = false
		movement = Vector2.ZERO
		x_movement_factor = 0
		get_tree().paused = false

	

func pixel_transition():
	get_tree().paused = true
	$CanvasLayer/Pixelate.visible = true
	$AnimationPlayer.play('pixelate')


func emit_pixel_transition_signal():
	pixel_transition_finished.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().paused = false 
	$CanvasLayer/Pixelate.visible = false	


func _on_camera_north_trigger_body_entered(body: Node2D) -> void:
	if not moving and body.is_in_group('player'):
		moving = true
		movement.y = -1


func _on_camera_east_trigger_body_entered(body: Node2D) -> void:
	if not moving and body.is_in_group('player'):
		moving = true
		movement.x = -1


func _on_camera_south_trigger_body_entered(body: Node2D) -> void:
	if not moving and body.is_in_group('player'):
		moving = true
		movement.y = 1


func _on_camera_west_trigger_body_entered(body: Node2D) -> void:
	if not moving and body.is_in_group('player'):
		moving = true
		movement.x = 1
