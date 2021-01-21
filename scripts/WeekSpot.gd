extends Area2D

signal damage(damage, node)

func hit(damage, node):
	emit_signal("damage", damage, node)
