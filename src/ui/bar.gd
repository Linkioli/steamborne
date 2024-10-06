extends Control

var player 


func _ready() -> void:
	call_deferred("_connect_player_signal")


func _connect_player_signal():
	player = Global.player
	if player == null:
		print("Player is null")
	else:
		player.damaged.connect(_on_player_damaged)


func _on_player_damaged():
	$HealthBar.set_animation(str(player.health))
