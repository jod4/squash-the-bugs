extends RigidBody3D


func initialize(start_position):
	position = start_position
	rotate_y(randf_range(-PI, PI))
	rotate_x(randf_range(-PI, PI))
	rotate_z(randf_range(-PI, PI))


func _on_visibility_notifier_screen_exited() -> void:
	queue_free()


func _on_collision_detector_body_entered(body: Node3D) -> void:
	if body.name == "Ground":
		$AnimationPlayer.play("fade")
	if body.name == "Player":
		PlayerVariables.hit.emit()
