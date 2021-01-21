extends Node

var score = 0 setget set_score

signal score_changed

func _ready():
	pass # Replace with function body.

func add_score(value):
	score += value
	emit_signal("score_changed")

func set_score(_value):
	print('cant write score, use add_score')
	pass
