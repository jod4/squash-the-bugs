extends CharacterBody3D

@export var min_speed = 10
@export var max_speed = 18

signal squashed


func  _physics_process(_delta: float) -> void:
	move_and_slide()


func initialize(start_position, player_position):
	var flat_player_position = player_position
	
	flat_player_position.y = start_position.y
	
	look_at_from_position(start_position, flat_player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.speed_scale = float(random_speed) / float(min_speed)


func squash() -> void:
	squashed.emit()
	queue_free()


func _on_visibility_notifier_screen_exited() -> void:
	queue_free()
