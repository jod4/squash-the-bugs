extends Node

@export var mob_scene: PackedScene
@export var stone_scene: PackedScene


func _ready() -> void:
	$UI/Retry.hide()


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $SpawnPath/SpawnLocation
	mob_spawn_location.progress_ratio = randf()
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	add_child(mob)
	mob.squashed.connect($UI/ScoreLabel._on_mob_squashed.bind())


func _on_stone_timer_timeout() -> void:
	var stone = stone_scene.instantiate()
	var stone_spawn_location = $StoneSpawnArea
	var randX = randf() * stone_spawn_location.mesh.size.x / 2
	if randi() % 2:
		randX = -randX
	var randZ = randf() * stone_spawn_location.mesh.size.y / 2
	if randi() % 2:
		randZ = -randZ
	var stone_position = Vector3(randX, stone_spawn_location.position.y - 2, randZ)
	stone.initialize(stone_position)
	add_child(stone)


func _on_player_hit() -> void:
	$Timers/MobTimer.stop()
	$UI/Retry.show()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UI/Retry.visible:
		get_tree().reload_current_scene()
