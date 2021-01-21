extends Area2D

const rot_velocity = PI * 0.2
const PRE_MISSEL = preload("res://scenes/HOMEMissel.tscn")

func _ready():
	pass

func get_target():
	var tank = get_parent().bodies[0]
	var ht = (tank.global_position - global_position).normalized()
	var facing = Vector2(cos(rotation), sin(rotation))
	# verifica se esta na area de visão
	if ht.dot(facing) > 0.5:
		if $FireTimer.is_stopped():
			fire()
			$FireTimer.start()
	else:
		$FireTimer.stop()
		
	return null

func fire():
	if get_parent().bodies.size():
		$AudioFire.play()
		$AnimationPlayer.play("fire")
		var missel = PRE_MISSEL.instance()
		get_parent().add_child(missel)
		missel.rotation = rotation
		var tank = get_parent().bodies[0]
		missel.target = tank
		missel.global_position = $Position2D.global_position
	else :
		$FireTimer.stop()

func _on_FireTimer_timeout():
	fire()
