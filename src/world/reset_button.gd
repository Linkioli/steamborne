extends Area2D


func _ready() -> void:
	DynamicTiles.occupied_grids.append(floor(global_position / 16))


func _process(delta: float) -> void:
	pass
