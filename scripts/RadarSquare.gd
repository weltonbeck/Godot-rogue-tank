extends ColorRect

export var area_size = Vector2()

var rate

func _ready():
	rate = get_rect().size / area_size
	

func _draw():
	for re in get_tree().get_nodes_in_group("radar_entity"):
		draw_circle(re.global_position * rate, 2, Color(1,1,1,1))
	for re in get_tree().get_nodes_in_group("player"):
		draw_circle(re.global_position * rate, 2, Color(0,1,0,1))

func _on_TimerUpdate_timeout():
	update()
