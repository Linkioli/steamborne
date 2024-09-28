extends Sprite2D

@export var projectile_scene: PackedScene
@export_enum('up', 'down', 'left', 'right') var direction: String = 'up'


func fire():
	var projectile = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.fire($Marker2D.global_position, direction)


func _on_fire_timer_timeout() -> void:
	fire()
