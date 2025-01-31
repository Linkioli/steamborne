extends TileMap

var next_level

func _ready() -> void:
	Global.player = $Player
	Global.camera = $Camera


func _on_level_switch_component_level_changed(level) -> void:
	next_level = level
	$Camera.fade('out')


func _on_camera_fade_transition_finished() -> void:
	Global.change_level(next_level)
