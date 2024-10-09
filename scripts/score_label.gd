extends Label

var score = 0

func _on_mob_squashed() -> void:
	score += PlayerVariables.score_multiplier
	text = "Score: %s" % score
	$AudioSquash.play()
