extends TileMap


func _ready() -> void:
	Global.player = $Player
	Global.camera = $Camera

	if Global.area_1_player_spawn_pos != null:
		print('test')
		$Player.position = Global.area_1_player_spawn_pos
	if Global.area_1_camera_spawn_pos != null:
		$Camera.position = Global.area_1_camera_spawn_pos


func _on_level_switch_component_level_changed(level) -> void:
	Global.area_1_player_spawn_pos = Vector2(74, 330)
	Global.area_1_camera_spawn_pos = Vector2 (0, 224)
	Global.change_level(level)
