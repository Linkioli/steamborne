extends Area2D 
class_name LevelSwitchComponent

@export var level_file_path: String 
signal level_changed

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print('test')
	level_changed.emit(level_file_path)
