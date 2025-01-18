extends TileMap


func _ready() -> void:
	Global.player = $Player
	Global.camera = $Camera

func change_level(level):
	get_tree().change_scene_to_packed(level)


func _on_level_switch_component_level_changed(level) -> void:
	print(level)
	change_level(level)
