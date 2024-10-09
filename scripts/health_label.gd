extends Label

var health = 3


func _ready() -> void:
	PlayerVariables.connect("hit", Callable(self, "_on_player_hit"))


func _on_player_hit() -> void:
	health -= 1
	if health <= 0:
		PlayerVariables.die.emit()
	text = "Health: %s" % health
	$AudioHit.play()
