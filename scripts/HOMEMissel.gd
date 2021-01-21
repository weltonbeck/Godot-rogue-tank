extends Area2D

var target
var rot_velocity = PI
var velocity = 100
var homming = false

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	homming = true

func _process(delta):
	if target:
		if homming:
			var angle = get_angle_to(target.global_position)
			if abs(angle) > 0.01:
				rotation += sign(angle) * rot_velocity *  delta
		translate(Vector2(cos(rotation), sin(rotation)).normalized() * velocity * delta)

func _on_HOMEMissel_body_entered(body):
	destroy()
	if body.get_node("DamageArea") && body.get_node("DamageArea").has_method("hit"):
		body.get_node("DamageArea").hit(10, self)


func _on_AreaDamage_destroid():
	destroy()

func destroy():
	$AreaDamage.queue_free()
	$Explosion.play("explode")
	$Sprite.hide()
	$CollisionShape2D.queue_free()
	set_process(false)
	$ParticlesSmoke.emitting = false
	$ParticlesFire.emitting = false
	yield(get_tree().create_timer(2), "timeout")
	queue_free()

