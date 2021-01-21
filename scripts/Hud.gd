extends CanvasLayer

func _ready():
	Game.connect("score_changed", self, "on_score_changed")
	write_score()
	pass

func on_score_changed():
	write_score()

func write_score():
	$ScoreLabel.text = str(Game.score)
