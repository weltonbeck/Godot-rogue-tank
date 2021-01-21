extends Area2D


func _ready():
	
	pass


func _on_OilSpillLarge_body_entered(body):
	#insere no grupo (idenficador do tank) - oil
	add_to_group(str(body) + "-oil")


func _on_OilSpillLarge_body_exited(body):
	#remove do grupo (idenficador do tank) - oil
	remove_from_group(str(body) + "-oil")
