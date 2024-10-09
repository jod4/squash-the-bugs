extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16

var target_velocity: Vector3 = Vector3.ZERO
var is_still_on_floor: bool = false

signal hit


func _ready() -> void:
	PlayerVariables.connect("die", Callable(self, "_on_player_die"))
	PlayerVariables.connect("hit", Callable(self, "_on_player_hit"))


func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if $AnimationPlayer.current_animation == "die":
		$AnimationPlayer.speed_scale = 1
	else:
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_forward"):
			direction.z -= 1
		if Input.is_action_pressed("move_back"):
			direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	else:
		$AnimationPlayer.speed_scale = 1
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if is_on_floor():
		$Pivot.rotation.x = deg_to_rad(-4.2)
		if Input.is_action_just_pressed("jump") and $AnimationPlayer.current_animation != "die":
			target_velocity.y = jump_impulse
			is_still_on_floor = false
			$AudioJump.play()
		if is_still_on_floor == false:
			is_still_on_floor = true
			PlayerVariables.score_multiplier = PlayerVariables.INITIAL_SCORE_MULTIPLIER
	else:
		$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)		
	
	# collision
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
		
		if collider == null:
			continue
		
		if collider.is_in_group("mob"):
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				collider.squash()
				PlayerVariables.score_multiplier *= 2
				target_velocity.y = bounce_impulse
				break
	
	velocity = target_velocity
	
	move_and_slide()


func _on_mob_detector_body_entered(_body: Node3D) -> void:
	PlayerVariables.hit.emit()


func _on_player_hit() -> void:
	$AnimationPlayer.play("hit")


func _on_player_die() -> void:
	$AnimationPlayer.play("die")
	PlayerVariables.score_multiplier = PlayerVariables.INITIAL_SCORE_MULTIPLIER


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "die"):
		hit.emit()
