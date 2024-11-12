extends Node2D

@export var rail_cart = false

func _ready() -> void:
	var grid_pos = floor(global_position / 16)
	if rail_cart:
		DynamicTiles.occupied_rail_grids.append(grid_pos)
	else:
		DynamicTiles.occupied_grids.append(grid_pos)
