extends Camera2D

@export var player: CharacterBody2D
@export var skybox_enabled = false
@onready var size = Vector2(256, 224)

const SPEED = 4

var moving = false
var x_movement_factor = 0
var y_movement_factor = 0
var movement = Vector2.ZERO
var fade_alpha = 0
var fade_mode = null

signal pixel_transition_finished
signal fade_transition_finished


func _ready() -> void:
	if skybox_enabled:
		$Skybox.visible = true
	else:
		$Skybox.visible = false
	
	fade_alpha = 1
	fade_mode = 'in'

	$CanvasLayer/ScreenFade.color = Color(0, 0, 0, fade_alpha)

func _process(delta: float) -> void:
	global_position += movement * SPEED

	$CanvasLayer/ScreenFade.color = Color(0, 0, 0, fade_alpha)
	if fade_mode != null:
		get_tree().paused = true
		fade_transition()

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


func fade(mode: String):
	fade_mode = mode


func fade_transition():
	if fade_mode == 'in' and fade_alpha > 0:
		fade_alpha -= 0.1
	elif fade_mode == 'out' and fade_alpha < 1:
		fade_alpha += 0.1
	elif fade_mode == 'out' and fade_alpha >= 1:
		fade_mode = null
		fade_transition_finished.emit()
	else:
		fade_mode = null
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
