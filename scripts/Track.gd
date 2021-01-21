extends Node2D

func _ready():
	$Timer.wait_time = rand_range(3, 6)
	$Timer.start()

func _on_Timer_timeout():
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
