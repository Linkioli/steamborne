extends Area2D 
class_name LevelSwitchComponent

@export var level: PackedScene
signal level_changed

func _on_body_entered(body: Node2D) -> void:
	level_changed.emit(level)
