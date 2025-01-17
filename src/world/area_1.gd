extends TileMap


func _ready() -> void:
	Global.player = $Player
	Global.camera = $Camera
