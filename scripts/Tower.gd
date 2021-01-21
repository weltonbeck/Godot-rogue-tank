tool
extends StaticBody2D

var first_draw = true

var bodies = []

export(float, 0, 360) var rotation_inicial = 0.0 setget set_rotation_inicial
export var life = 100
export(int, 'HMG', 'HOME') var type = 0 setget set_type
onready var initial_life = life

var dead = false

onready var cannon = $HMGCannon

signal player_entered(n)
signal player_exited(n)

func _draw():
	if dead:
		return
	if Engine.editor_hint:
		$HMGCannon.visible = type == 0
		$HOMECannon.visible = type == 1
	if type == 0:
		cannon = $HMGCannon
	elif type == 1:
		cannon = $HOMECannon
		
	if first_draw:
		cannon.rotation =  deg2rad(rotation_inicial)
		if ! Engine.editor_hint :
			first_draw = false
			cannon.visible = true
			if type == 0:
				$HOMECannon.queue_free()
			elif type == 1:
				$HMGCannon.queue_free()
	if ! dead:
		draw_circle_arc(Vector2(),$Sensor/CollisionShape2D.shape.radius,0 , 360, Color(1,0,0,0.5))
		if bodies.size():
			draw_circle(Vector2(), $Sensor/CollisionShape2D.shape.radius, Color(1,0,0,0.1))
	
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func _process(delta):
	if Engine.editor_hint :
		return
		
	if ! dead && bodies.size() > 0:
		var target = cannon.get_target()
		var angle = cannon.get_angle_to(bodies[0].global_position)
		if abs(angle) > 0.01:
			cannon.rotation += sign(angle) * cannon.rot_velocity *  delta
			
		if target != null &&  target != bodies[0]:
			var old_bodie = bodies[0]
			var new_body_index = bodies.find(target)
			bodies[0] = target.get_collider()
			bodies[new_body_index] = old_bodie

func _on_Sensor_body_entered(body):
	bodies.append(body)
	emit_signal("player_entered", bodies.size())
	update()

func _on_Sensor_body_exited(body):
	var index = bodies.find(body)
	if index >= 0:
		bodies.remove(index)
	emit_signal("player_exited", bodies.size())
	update()
	
func set_rotation_inicial(value):
	rotation_inicial = value
	if Engine.editor_hint :
		cannon.rotation =  deg2rad(value)

func _on_WeekSpot_damage(damage, _node):
	life -= damage
	$AudioDamage.play()
	$HPNode/HPBar.scale = float(life) / float(initial_life)
	if life <= 0:
		dead = true
		cannon.queue_free()
		$Sensor.disconnect("body_exited", self, "_on_Sensor_body_exited")
		$Sensor.queue_free()
		$WeekSpot.queue_free()
		$HPNode/HPBar.queue_free()
		$AudioExplosion.play()
		$Explosion/AnimationPlayer.play("explosion")
		get_tree().call_group("camera", "shake", 5, 1)
		Game.add_score(250)
		remove_from_group("radar_entity")
		update()

func set_type(value):
	type = value
	if Engine.editor_hint:
		update()
