extends Area2D

var damage = 2
var max_distance = 150
var speed = 400
var direction = Vector2(0, 0)
onready var initial_position = global_position

var shooter

func _physics_process(delta):
	# caso esteja longe do ponto de inicio
	if global_position.distance_to(initial_position) > max_distance:
		self_destruction()
			
	translate(direction * speed * delta)


func _on_MachinegunBullet_area_entered(area):
	if area.has_method("hit"):
		area.hit(damage, self)
		self_destruction()

func self_destruction() :
	queue_free()

func _on_MachinegunBullet_body_entered(_body):
	self_destruction()
