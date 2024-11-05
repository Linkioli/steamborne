extends Area2D


func _process(delta: float) -> void:
	if DynamicTiles.get_grid_position(global_position) in DynamicTiles.occupied_grids:
		reset()


func reset():
	Global.camera.pixel_transition_finished.connect(_on_pixel_transition_finished)
	Global.camera.pixel_transition()


func _on_pixel_transition_finished() -> void:
	for node in get_children():
		if node.is_in_group('resetable_objects'):
			node.reset()


func _on_body_entered(body: Node2D) -> void:
	if body == Global.player:
		reset()
