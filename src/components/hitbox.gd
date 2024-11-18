extends Area2D
class_name HitboxComponent

signal damaged(amount)

func damage(amount=1):
	damaged.emit(amount)	
