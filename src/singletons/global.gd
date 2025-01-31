extends Node

var player
var camera

func change_level(level):
	get_tree().change_scene_to_file(level)
