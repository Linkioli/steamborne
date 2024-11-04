extends Camera2D

@export var player: CharacterBody2D
@onready var size = Vector2(160, 128)

const SPEED = 4

var moving = false
var x_movement_factor = 0
var y_movement_factor = 0
var movement = Vector2.ZERO


func _process(delta: float) -> void:
	global_position += movement * SPEED
	if movement.y:
		y_movement_factor += SPEED
		get_tree().paused = true
	if y_movement_factor >= size.y:
		movement = Vector2.ZERO
		y_movement_factor = 0
		get_tree().paused = false
	if movement.x:
		x_movement_factor += SPEED
		get_tree().paused = true
	if x_movement_factor >= size.x:
		movement = Vector2.ZERO
		x_movement_factor = 0
		get_tree().paused = false

	if Input.is_action_just_pressed('ui_page_up'):
		var current_screen_image = get_viewport().get_texture().get_image()
		$ShaderTexture.texture = ImageTexture.create_from_image(current_screen_image)
		$AnimationPlayer.play('pixelate')


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$ShaderTexture.texture = null


func _on_camera_north_trigger_body_entered(body: Node2D) -> void:
	if not moving and body.is_in_group('player'):
		movement.y = -1


func _on_camera_east_trigger_body_entered(body: Node2D) -> void:
	if not moving and body.is_in_group('player'):
		movement.x = -1


func _on_camera_south_trigger_body_entered(body: Node2D) -> void:
	if not moving and body.is_in_group('player'):
		movement.y = 1


func _on_camera_west_trigger_body_entered(body: Node2D) -> void:
	if not moving and body.is_in_group('player'):
		movement.x = 1
