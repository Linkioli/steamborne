extends Area2D

var direction = Vector2.ZERO

const SPEED = 100 


func fire(pos, dir):
	global_position = pos	
	match dir:
		'up': direction.y = -1
		'down': direction.y = 1
		'left': direction.x = -1
		'right': direction.x = 1


func _ready() -> void:
	$CollisionShape2D.disabled = true
	$CollisionTimer.start()


func _process(delta: float) -> void:
	position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		queue_free()
	if body.is_in_group('world_collisions'):
		queue_free()


func _on_collision_timer_timeout() -> void:
	$CollisionShape2D.disabled = false
