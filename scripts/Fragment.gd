extends RigidBody2D

export var bouncing = 0.3

func _ready():
	randomize()
	# para caso a scala esteja diferente no pai
	$Polygon2D.scale = get_parent().scale
	$CollisionPolygon2D.scale = get_parent().scale
	gravity_scale = 0
	linear_damp = 1
	angular_velocity = randf() * 10
	bounce = bouncing
	#gera um numero aleatorio de 0 a 1
	var direction = randf() * PI * 2
	apply_impulse(Vector2(), Vector2(cos(direction), sin(direction) * 100))
	connect("sleeping_state_changed", self, "on_self_sleeping_state_changed")
	
# evento de quando para de se movimentar e volta a dormir
func on_self_sleeping_state_changed():
	if sleeping :
		var t = get_tree().create_timer(randf() * 4 + 2)
		# espera o tempo
		yield(t, "timeout")
		
		var tween = Tween.new()
		add_child(tween)
		# interpola os valores
		tween.interpolate_method(self, "fade", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		queue_free()
		
func fade(value) :
	$Polygon2D.modulate = value
	pass
