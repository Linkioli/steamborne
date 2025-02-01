extends CharacterBody2D

const SPEED = 85
const KNOCKBACK_SPEED = -250

var health = 6

var direction: Vector2
var idle_direction
var knockback_vector: Vector2

var is_knockback = false
var immune = false
var attacking = false

var current_state
enum State {IDLE, WALK, PUSH, STAB}

signal damaged

@onready var animation_tree: AnimationTree = $AnimationTree

@export_enum('up', 'down', 'left', 'right') var starting_direction = 'down' 


# TODO: Fix bug where player's starting direction doesn't update due to the scene being paused from the camera's transition effect 
func _ready() -> void:
	animation_tree.active = true
	$HurtBoxPivot/HurtBox/CollisionShape2D.disabled = true

	match starting_direction:
		'up':
			animation_tree["parameters/Idle/blend_position"] = Vector2.UP
			$AnimationPlayer.play('idle_up')
		'down':
			idle_direction = Vector2.DOWN
			direction = Vector2.DOWN
		'left':
			idle_direction = Vector2.LEFT
			direction = Vector2.LEFT
		'right':
			idle_direction = Vector2.RIGHT
			direction = Vector2.RIGHT


func _process(delta: float) -> void:
	update_animation_parameters()

	# playing blinking on immune timer
	if immune:
		if sin(Time.get_ticks_msec()) <= 0:
			$Sprite2D.visible = true
		else:
			$Sprite2D.visible = false


func _physics_process(delta: float) -> void: 
	direction = Input.get_vector("left", "right", "up", "down")
	if attacking:
		direction = Vector2.ZERO

	if is_knockback:
		knockback()
	else:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED

	state_machine()
	attack_manager()	
	move_and_slide()


func damage(amount=1):
	if not immune:
		health -= amount
		immune = true
		$ImmuneTimer.start()
		$KnockBackTimer.start()
		is_knockback = true
		damaged.emit()


func knockback():
	velocity.x = knockback_vector.x * KNOCKBACK_SPEED
	velocity.y = knockback_vector.y * KNOCKBACK_SPEED


func attack_manager():
	if direction != Vector2.ZERO:
		if direction.y != 0 and direction.x != 0:
			if direction.y > 0:
				idle_direction = Vector2.DOWN
			if direction.y < 0:
				idle_direction = Vector2.UP
		else:
			idle_direction = direction
		knockback_vector = direction	

	match idle_direction:
		Vector2.DOWN:
			$HurtBoxPivot.rotation_degrees = 0
		Vector2.UP:
			$HurtBoxPivot.rotation_degrees = 180
		Vector2.LEFT:
			$HurtBoxPivot.rotation_degrees = 90
		Vector2.RIGHT:
			$HurtBoxPivot.rotation_degrees = -90
	
	if attacking and $HurtBoxPivot/HurtBox/CollisionShape2D.disabled == true:
		$HurtBoxPivot/HurtBox/CollisionShape2D.disabled = false
	elif not attacking:
		$HurtBoxPivot/HurtBox/CollisionShape2D.disabled = true 


func attack_finished():
	attacking = false


func state_machine():
	if attacking:
		current_state = State.STAB
		return
	 
	if Input.is_action_just_pressed("attack") and not attacking:
		attacking = true
		current_state = State.STAB

	if velocity == Vector2.ZERO:
		current_state = State.IDLE
	else:
		if is_on_wall() and velocity.y == 0:
			current_state = State.PUSH
		elif is_on_floor() and velocity.x == 0:
			current_state = State.PUSH
		elif is_on_ceiling() and velocity.x == 0:
			current_state = State.PUSH
		else:
			current_state = State.WALK


func update_animation_parameters():
	match current_state:
		State.IDLE:
			animation_tree["parameters/conditions/idle"] = true
			animation_tree["parameters/conditions/is_moving"] = false
			animation_tree["parameters/conditions/is_pushing"] = false 
			animation_tree['parameters/conditions/is_stabbing'] = false
		State.WALK:
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/is_moving"] = true
			animation_tree["parameters/conditions/is_pushing"] = false 
			animation_tree['parameters/conditions/is_stabbing'] = false
		State.PUSH:
			animation_tree["parameters/conditions/idle"] = false 
			animation_tree["parameters/conditions/is_moving"] = false
			animation_tree["parameters/conditions/is_pushing"] = true
			animation_tree['parameters/conditions/is_stabbing'] = false
		State.STAB:
			animation_tree["parameters/conditions/idle"] = false 
			animation_tree["parameters/conditions/is_moving"] = false
			animation_tree["parameters/conditions/is_pushing"] = false
			animation_tree['parameters/conditions/is_stabbing'] = true

	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
		animation_tree["parameters/Push/blend_position"] = direction
		animation_tree["parameters/Stab/blend_position"] = direction


func _on_knock_back_timer_timeout() -> void:
	is_knockback = false	


func _on_immune_timer_timeout() -> void:
	immune = false	
	$Sprite2D.visible = true


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox"):
		area.damage()
	
