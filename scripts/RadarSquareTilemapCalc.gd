extends Node

export(NodePath) var tilemap

func _ready():
	if tilemap:
		tilemap = get_node(tilemap) 
		if tilemap is TileMap:
			var area_size = (tilemap.cell_size * tilemap.get_used_rect().size)
			get_parent().area_size = area_size
	queue_free()
