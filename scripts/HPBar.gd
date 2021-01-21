extends ColorRect

onready var initial_rect_size = rect_size
var scale = 1 setget set_scale

var is_vertical = false

func _ready():
	if initial_rect_size.y > initial_rect_size.x:
		is_vertical = true
		rect_rotation = 180
		rect_position += rect_size

func _draw():
	draw_rect(Rect2(Vector2(), initial_rect_size), Color(0,0,0), false)
	pass

func set_scale(value):
	scale = value
	if is_vertical:
		rect_size.y = initial_rect_size.y * scale
	else :
		rect_size.x = initial_rect_size.x * scale
