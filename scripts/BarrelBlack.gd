extends StaticBody2D

const PRE_OIL = preload("res://scenes/OilSpillLarge.tscn")
var last_hit_node

func _ready():
	$AreaObstacle.connect("hitted", self, "on_area_hitted")
	$AreaObstacle.connect("destroid", self, "on_area_destroid")
	pass

func on_area_hitted(damage, health, node):
	last_hit_node = node
	if health > 0:
		if damage > 5:
			$AudioBigHit.play()
		else :
			var hit_sound = "AudioSmallHit" + str(randi() % 5 + 1)
			print(hit_sound)
			get_node(hit_sound).play()
		$AnimationPlayer.play("hit")
	else :
		$AudioExplode.play()

func on_area_destroid():
	$AnimationPlayer.play("explode")
	if last_hit_node && "shooter" in last_hit_node:
		if last_hit_node.shooter.get_filename() == "res://scenes/Tank.tscn":
			Game.add_score(80)
	$AreaObstacle.queue_free()
	var oil_count = rand_range(3, 5)
	for o in range(oil_count):
		var oil = PRE_OIL.instance()
		var angle = randf() * (PI * 2)
		oil.global_position = global_position + Vector2(cos(angle), sin(angle)).normalized() * rand_range(30, 60)
		oil.z_index = z_index -1
		#get_parent().add_child(oil)
		get_parent().call_deferred("add_child", oil)
	yield($AnimationPlayer, "animation_finished")
	queue_free()
