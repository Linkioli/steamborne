extends Node2D


func _ready() -> void:
	var grid_pos = floor(global_position / 16)
	DynamicTiles.occupied_grids.append(grid_pos)
