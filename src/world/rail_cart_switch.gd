extends Area2D


func press():
	for node in get_children():
		if node.is_in_group("gate") and not node.opened:
			node.open()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('rail_cart'):
		press()
