extends Node

var occupied_grids = []
var occupied_rail_grids = []


func get_grid_position(pos: Vector2):
	return floor(pos / 16)
