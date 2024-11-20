extends StaticBody2D

var opened = false


func open():
	$AnimatedSprite2D.play("open")


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.disabled = true
	opened = true
