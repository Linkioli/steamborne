extends StaticBody2D


func _process(delta: float) -> void:
	y_sort()

func y_sort():
	var player_pos = Global.player.global_position
	if global_position.y <= player_pos.y:
		z_index = 0
	elif global_position.y >= player_pos.y:
		z_index = 1
