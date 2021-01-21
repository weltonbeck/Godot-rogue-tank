extends Area2D

var max_distance = 250

var damage = 10
var speed = 400
var direction = Vector2(0, -1) setget set_direction
onready var initial_position = global_position
var live = true

var shooter

func _ready():
	pass

func _process(delta):
	if live :
		# caso esteja longe do ponto de inicio
		if global_position.distance_to(initial_position) > max_distance:
			self_destruction()
		
		translate(direction * speed * delta)
		
func self_destruction() :
	live = false
	$ParticlesSmoke.emitting = false
	$Sprite.hide()
	$AnimationSelfDestruction.play("explode")
	# estes monitore desligam ele das fisicas de colisão
	#monitorable = false
	# da erro se usar o de cima pq não posso desligar o monitoramento 
	# no meio de um loop de uso dele (_on_Bullet_body_entered)
	# esta função de baixo manda esperar um pouco
	call_deferred("set_monitorable", false)
	#monitoring = false
	call_deferred("set_monitoring", false)
	# espera a animação acabar e só então da sequencia
	yield($AnimationSelfDestruction, "animation_finished")
	queue_free()

# avisa que saiu da tela
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# sempre q editar a direção
func set_direction(value):
	direction = value
	rotation = direction.angle()

# quando colidir com algo
func _on_Bullet_body_entered(_body):
	self_destruction()

func _on_Bullet_area_entered(area):
	if area.has_method("hit"):
		area.hit(damage, self)
		self_destruction()
