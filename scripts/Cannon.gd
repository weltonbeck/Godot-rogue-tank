extends Area2D

const rot_velocity = PI * 0.5

const PRE_BULLET = preload("res://scenes/TowerBullet01.tscn")

func _ready():
	get_parent().connect("player_entered", self, "on_player_entered")
	get_parent().connect("player_exited", self, "on_player_exited")
	pass

func get_target():
	if $RayCast2D.is_colliding():
		return $RayCast2D.get_collider()
	return null

func on_player_entered(n) :
	if n:
		$ShootTimer.start()
		$RayCast2D.enabled = true

func on_player_exited(n):
	if n:
		$RayCast2D.enabled = false
		$ShootTimer.stop()
		$Smoke.emitting = false
		
func _on_ShootTimer_timeout():
	if $RayCast2D.is_colliding() :
		$Smoke.emitting = true
		$AnimationPlayer.play("shoot")
		$AudioStreamPlayer.play()
		var bullet = PRE_BULLET.instance()
		bullet.global_position = $Position2D.global_position
		bullet.direction = Vector2(cos(rotation), sin(rotation))
		#bullet.max_distance = get_parent().sensor_radius
		get_parent().get_parent().add_child(bullet)
	else :
		$Smoke.emitting = false
