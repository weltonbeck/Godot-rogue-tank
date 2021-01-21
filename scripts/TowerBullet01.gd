extends Area2D

var direction = Vector2() setget set_direction
var velocity = 200
var max_distance = 300
onready var initial_position = global_position

func _ready():
	pass

func _physics_process(delta):
	translate(direction * velocity * delta)
	if global_position.distance_to(initial_position) >= max_distance:
		queue_free()

func set_direction(value):
	rotation = value.angle()
	direction = value


func _on_TowerBullet01_area_entered(area):
	if area.has_method("hit"):
		area.hit(5, self)
		queue_free()
