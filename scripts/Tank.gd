tool # avisa que tem ferramentas e deve execurar em edição
extends KinematicBody2D

# onready só execura quando esta pronto
onready var BULLET_TANK_GROUP = "bullet-" + str(self)

# pi = 180 graus
const ROTATE_VALUE = PI / 2
const DEATH_ZONE = 0.02

signal cannon_shooted
signal machinegun_shooted

var max_speed = 100
var acceleration = 0
var pre_bullet = preload("res://scenes/Bullet.tscn")
var pre_mg_bullet = preload("res://scenes/MachinegunBullet.tscn")
var pre_track = preload("res://scenes/Track.tscn")
var travel = 0
var can_mouse_look = false
var loaded = true

onready var initial_life = $DamageArea.health

export(int, "blue", "dark", "green", "red", "sand", "darkLarge", "bigRed" ) var body = 0 setget set_body
export(int, "BlueBarrel", "DarkBarrel", "GreenBarrel", "RedBarrel", "SandBarrel", "specialBarrel" ) var barrel = 0  setget set_barrel

var bodies = [
	"res://sprites/tankBody_blue_outline.png",
	"res://sprites/tankBody_dark_outline.png",
	"res://sprites/tankBody_green_outline.png",
	"res://sprites/tankBody_red_outline.png",
	"res://sprites/tankBody_sand_outline.png",
	"res://sprites/tankBody_darkLarge_outline.png",
	"res://sprites/tankBody_bigRed_outline.png"
]

var barrels = [
	"res://sprites/tankBlue_barrel2_outline.png",
	"res://sprites/tankDark_barrel1_outline.png",
	"res://sprites/tankGreen_barrel2_outline.png",
	"res://sprites/tankRed_barrel2_outline.png",
	"res://sprites/tankSand_barrel2_outline.png",
	"res://sprites/specialBarrel3_outline.png"
]

func _ready():
	pass
	
func _draw():
	$Sprite.texture = load(bodies[body])
	$Barrel/Sprite.texture = load(barrels[barrel])
	
func _input(event):
	if event is InputEventMouseMotion :
		can_mouse_look = true

func _physics_process(delta):
	# caso esteja no modo editor manda sair
	if Engine.editor_hint :
		return
		
	# rotaciona o tank quando usa os direcionais
	var direction_rotation = 0
	#controle de joystick
	direction_rotation = Input.get_joy_axis(0, JOY_AXIS_0)
	direction_rotation = calcDeathZone(direction_rotation)
	if direction_rotation == 0 :
		direction_rotation = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	rotate(ROTATE_VALUE * direction_rotation * delta)
	
	# move pra frente
	var dir_y = 0
	#controle de joystick
	dir_y = Input.get_joy_axis(0, JOY_AXIS_1) * -1
	dir_y = calcDeathZone(dir_y)
	if dir_y == 0 :
		dir_y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	var direction = Vector2(cos(rotation),sin(rotation))
	# vai progredindo a aceleração aos poucos
	acceleration = lerp(acceleration, max_speed * dir_y, 0.03)
	
	var velocity_mod = 1
	# verifica se existe algum elemento no grupo (idenficador do tank) - oil
	if get_tree().get_nodes_in_group(str(self) + "-oil").size() > 0 :
		velocity_mod = 0.3
	
	var move = move_and_slide(direction * acceleration * velocity_mod)
	travel += move.length() * delta
	
	#olha pro mouse ou joystick 
	var r_hor_axis = Input.get_joy_axis(0, JOY_AXIS_2)
	var r_ver_axis = Input.get_joy_axis(0, JOY_AXIS_3)
	r_hor_axis = calcDeathZone(r_hor_axis)
	r_ver_axis = calcDeathZone(r_ver_axis)
	# caso movimentar o joystick
	if (r_hor_axis != 0 || r_ver_axis != 0) :
		can_mouse_look = false
		$Barrel.global_rotation = Vector2(r_hor_axis, r_ver_axis).normalized().angle()
	# caso movimentar o mouse
	if can_mouse_look :
		$Barrel.look_at(get_global_mouse_position())
		
	shoot()
	track()
	
	if Input.is_action_just_pressed("ui_machinegun") :
		machinegun_shoot()
		$TimerMachinegun.start()
	if Input.is_action_just_released("ui_machinegun") :
		$TimerMachinegun.stop()
	

func shoot():
	# caso precionar ui_shoot
	if Input.is_action_pressed("ui_shoot") && loaded:
#		# caso só tenha 3 na tela
#		if get_tree().get_nodes_in_group(BULLET_TANK_GROUP).size() < 6:
		# instancia a bala
		var bullet = pre_bullet.instance()
		# adiciona em um grupo com o nome do tank
		bullet.add_to_group(BULLET_TANK_GROUP)
		# coloca a bala na ponta do canhão
		bullet.global_position = $Barrel/Muzzle.global_position
		# rotaciona direção a bala
		bullet.direction = Vector2(cos($Barrel.global_rotation), sin($Barrel.global_rotation)).normalized()
		# seta a distancia maxima
		bullet.max_distance = $Barrel/Sight.position.x - $Barrel/Muzzle.position.x
		# insere a bala na cena
		bullet.shooter = self
		get_parent().add_child(bullet)
#		$"../".add_child(bullet) # igual o de cima
		# anima o fogo
		$Barrel/AnimationPlayer.stop()
		$Barrel/AnimationPlayer.play("fire")
		#$AudioCannon.play()
		emit_signal("cannon_shooted")
		loaded = false
		$Barrel/Sight.update()
		$TimerReload.start()

func machinegun_shoot():
	#$AudioMachinegun.play()
	emit_signal("machinegun_shooted")
	var bullet = pre_mg_bullet.instance()
	bullet.add_to_group(BULLET_TANK_GROUP)
	bullet.global_position = $Machinegun/Muzzle.global_position
	bullet.rotation = rotation
	bullet.shooter = self
	bullet.direction = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
	get_parent().add_child(bullet)
	
		
func track ():
	if travel > $Sprite.texture.get_size().y:
		travel = 0
		var track = pre_track.instance()
		track.global_position = global_position - Vector2(cos(rotation),sin(rotation)).normalized() * 5
		track.rotation = rotation
		get_parent().add_child(track)
			
func set_body(value) :
	body = value
	if Engine.editor_hint :
		update()

func set_barrel(value) :
	barrel = value
	if Engine.editor_hint :
		update()

func calcDeathZone(value):
	if abs(value) < DEATH_ZONE:
		return 0
	return value


func _on_TimerReload_timeout():
	loaded = true
	$Barrel/Sight.update()

func _on_TimerMachinegun_timeout():
	machinegun_shoot()

func _on_DamageArea_destroid():
	$Sprite.hide()
	$Explosion.play("explode")
	get_tree().call_group("camera", "shake", 5, 1)
	set_process(false)
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	pass

func _on_DamageArea_hitted(damage, health, node):
	$HPNode/HPBar.scale = float(health) / float(initial_life)
	
