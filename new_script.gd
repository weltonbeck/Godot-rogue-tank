extends Node2D

func _ready():
	$fragment.connect("tree_exited", self, "on_fragment_tree_exited")
	
func on_fragment_tree_exited():
	pass
