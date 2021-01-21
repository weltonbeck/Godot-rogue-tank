tool
extends Node2D

func _ready():
	pass


func _draw():
	var color = Color(1,0,0)
	if $"../../".loaded:
		color = Color(0,1,0)
	draw_circle(Vector2(),3, color)
