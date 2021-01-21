extends StaticBody2D

const PRE_FRAGMENTS = preload("res://scenes/fragments/CrateWoodFragments.tscn")

var last_hit_node

func _ready():
	$AreaObstacle.connect("hitted", self, "on_area_hitted")
	$AreaObstacle.connect("destroid", self, "on_area_destroid")
	pass

func on_area_hitted(damage, _health, node):
	last_hit_node = node
	if damage > 5 :
		$AnimationPlayer.play("big_hit")
	else :
		$AnimationPlayer.play("small_hit")	

func on_area_destroid():
	var fragments = PRE_FRAGMENTS.instance()
	fragments.global_position = global_position
	fragments.scale = scale
	# este call_deferred chama o metodo na parada do physics pra evitar erros
	get_parent().call_deferred("add_child", fragments)
	queue_free()
	if last_hit_node && "shooter" in last_hit_node:
		if last_hit_node.shooter.get_filename() == "res://scenes/Tank.tscn":
			Game.add_score(50)
