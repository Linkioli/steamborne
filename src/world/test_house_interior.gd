extends TileMap


func _ready() -> void:
	Global.player = $Player
	Global.camera = $Camera


func _on_level_switch_component_level_changed(level) -> void:
	Global.change_level(level)
