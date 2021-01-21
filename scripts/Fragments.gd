extends Node2D

func _ready():
	pass
	for c in get_children():
		c.connect("tree_exited", self, "on_fragment_tree_exited")

func on_fragment_tree_exited():
	var bodies = 0
	
	for c in get_children():
		if c is RigidBody2D:
			bodies += 1
			
	if bodies <= 1 :
		queue_free()
