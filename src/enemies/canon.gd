extends Sprite2D

@export var projectile_scene: PackedScene
@export_enum('up', 'down', 'left', 'right') var direction: String = 'up'


func fire():
	var projectile = projectile_scene.instantiate()
	projectile.fire($Marker2D.position, direction)


func _on_fire_timer_timeout() -> void:
	fire()
