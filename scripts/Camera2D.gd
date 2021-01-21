extends Camera2D

var intensity
var rot_angle = 0

func _ready():
	add_to_group("camera")
	set_process(false)
	
func _process(_delta):
	rot_angle += PI / 3
	offset = Vector2(sin(rot_angle), cos(rot_angle)) * intensity
	pass

func shake(tpm_intensity, duration):
	set_process(true)
	self.intensity = tpm_intensity
	get_tree().create_timer(duration).connect("timeout", self, "on_timeout")

func on_timeout():
	set_process(false)
