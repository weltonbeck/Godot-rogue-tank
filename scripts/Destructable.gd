extends Area2D

export var health = 30

signal hitted(damage, health, node)
signal destroid()

func hit(damage, node):
	health -= damage
	emit_signal("hitted", damage, health, node)
	if health <= 0:
		emit_signal("destroid")
