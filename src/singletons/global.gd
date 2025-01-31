extends Node

var player
var camera

var area_1_player_spawn_pos
var area_1_camera_spawn_pos

func change_level(level):
	get_tree().change_scene_to_file(level)
