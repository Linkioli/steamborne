extends Area2D 
class_name LevelSwitchComponent

@export var level: PackedScene


func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_packed(level)
