extends Node2D
class_name YsortComponent

@export var actor: Node

func _process(delta: float) -> void:
	y_sort()


func y_sort():
	var player_pos = Global.player.global_position
	if global_position.y <= player_pos.y:
		actor.z_index = 0
	elif global_position.y >= player_pos.y:
		actor.z_index = 1
