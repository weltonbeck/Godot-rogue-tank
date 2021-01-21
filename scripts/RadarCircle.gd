tool
extends Node2D

export(float, 10, 3000) var sensor_radius = 500
export(float, 10, 1000) var radius = 10 setget set_radius
export(Color) var color = Color(0,.6,0,.4) setget set_color
export(NodePath) var tank

onready var rate = radius / sensor_radius

func _ready():
	if ! Engine.editor_hint:
		if tank:
			tank = get_node(tank)
	
func _draw():
	draw_circle(Vector2(), radius, color)
	if ! Engine.editor_hint && tank and weakref(tank).get_ref():
		#desenha o tank
		draw_circle(Vector2(), 3, Color(1,1,0,1))
		for re in get_tree().get_nodes_in_group("radar_entity"):
			var angle = (tank.global_position - re.global_position).angle()
			var distance = tank.global_position.distance_to(re.global_position)
			if distance <= sensor_radius:
				draw_circle(Vector2(cos(angle), sin(angle)) * distance * rate * -1, 3, Color(1,0,0,1))

func set_radius(value):
	radius = value
	if Engine.editor_hint:
		update()
		
func set_color(value):
	color = value
	if Engine.editor_hint:
		update()


func _on_TimerUpdate_timeout():
	update()
